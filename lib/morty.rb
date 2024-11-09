# frozen_string_literal: true
# typed: true

require "sorbet-runtime"

class Module
  include T::Sig
  include T::Helpers
end

require "rack"
require "sorbet-schema"
require "json"
require_relative "morty/version"
require_relative "morty/scope"
require_relative "morty/service"
require_relative "morty/request_handler"
require_relative "morty/response"
require_relative "morty/loader"
require_relative "morty/dependency"

module Morty
  class WrongMethodError < StandardError; end

  # Represents a request with invalid parameters.
  class BadRequestError < StandardError
    attr_reader :message

    def initialize(message)
      super
      @message = message
    end
  end

  # The rack-compatible entry for morty. This
  # will be in charge of resolving our routes,
  # injecting dependencies, parsing body objects, etc.
  class App
    extend T::Sig

    def initialize
      @handlers = T.let(load_handlers, T::Hash[String, RequestHandler])
    end

    def call(env)
      request = Rack::Request.new(env)
      handler = find_handler(request)
      return path_not_found_response.finish if handler.nil?

      handler.call(request).finish
    rescue WrongMethodError
      response = Rack::Response.new
      response.status = 405
      response.finish
    rescue BadRequestError => e
      response = Rack::Response.new
      response.status = 422
      response.write(e.message)
      response.finish
    end

    private

    sig { params(request: Rack::Request).returns(T.nilable(RequestHandler)) }
    def find_handler(request)
      handler = @handlers[request.path]
      handler = matched_handler(request.path) if handler.nil?
      return if handler.nil?
      raise WrongMethodError if handler.writer? && read_request?(request)
      raise WrongMethodError if !handler.writer? && write_request?(request)

      handler
    end

    def matched_handler(path)
      match = @handlers.select do |handler_path, _|
        Regexp.new(handler_path).match?(path)
      end.first
      if match.nil?
        nil
      else
        match[1]
      end
    end

    sig { params(request: Rack::Request).returns(T::Boolean) }
    def write_request?(request)
      request.request_method&.downcase == "post" || request.request_method&.downcase == "put"
    end

    sig { params(request: Rack::Request).returns(T::Boolean) }
    def read_request?(request)
      request.request_method&.downcase == "get"
    end

    sig { returns(Rack::Response) }
    def path_not_found_response
      response = Rack::Response.new
      response.body = "There is nothing there"
      response.status = 404
      response
    end

    def load_handlers
      path_to_handler = {}
      Morty::SERVICE_TRACKER.each do |service_class|
        p1, p2 = pathify(service_class.name)
        service_class.__set_resulting_path(p1)
        path_to_handler[p1] = RequestHandler.new(service: service_class)
        path_to_handler[p2] = RequestHandler.new(service: service_class)
      end
      path_to_handler
    end

    def pathify(constant_name)
      current_constant_name = ""
      fragments = constant_name.split("::").map do |fragment|
        current_constant_name += (current_constant_name.empty? ? fragment : "::#{fragment}")
        klass = eval("::#{current_constant_name}")
        frag_str = to_snake(fragment.gsub(/([aA][pP][iI])|([sS][eE][rR][vV][iI][cC][eE])/, ""))
        unless !klass.respond_to?(:__suffix) || klass.__suffix.nil?
          frag_str += "/(?<#{klass.__suffix}>[a-zA-Z0-9_-]+/?)"
        end
        frag_str
      end
      ["/" + fragments.join("/"), "/" + fragments.join("/") + "/"]
    end

    def to_snake(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
            .gsub("_", "-")
    end
  end
end
