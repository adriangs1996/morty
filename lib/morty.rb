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
require_relative "morty/service"
require_relative "morty/request_handler"
require_relative "morty/response"

module Morty
  class WrongMethodError < StandardError; end

  class BadRequestError < StandardError
    attr_reader :message

    def initialize(message)
      super
      @message = message
    end
  end

  class Loader
    def self.load_services(path = "api")
      Dir["#{path}/**/*.rb"].sort.each do |f|
        require_relative(f)
      end
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
      return if handler.nil?
      raise WrongMethodError if handler.writer? && read_request?(request)
      raise WrongMethodError if !handler.writer? && write_request?(request)

      handler
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
        path_to_handler[p1] = RequestHandler.new(service: service_class)
        path_to_handler[p2] = RequestHandler.new(service: service_class)
      end
      path_to_handler
    end

    def pathify(constant_name)
      canonical_name = constant_name.gsub(/([aA][pP][iI])|([sS][eE][rR][vV][iI][cC][eE])/, "")
      fragments = canonical_name.split("::").map do |fragment|
        to_snake(fragment)
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
