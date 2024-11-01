# frozen_string_literal: true
# typed: true

require "rack"
require_relative "service"
require "sorbet-schema"

module Morty
  # Handle an incoming web request and return the web response.
  # The handler is in charge of initialize the data that the service
  # needs to run, or raise an error if it is not capable of doing so.
  class RequestHandler
    sig { params(service: T.untyped).void }
    def initialize(service:)
      @service = service
    end

    sig { returns(T::Boolean) }
    def writer?
      @service.writer_service?
    end

    sig { params(request: Rack::Request).returns(Rack::Response) }
    def call(request)
      response = Rack::Response.new
      response.add_header("Content-type", "application/json")
      data = if request.request_method == "GET"
               populate_data_from(parse_query_string(request.query_string))
             else
               populate_data_from(parse_query_string(request.query_string).merge(parse_body(request.body)))
             end
      service_response = if uses_parameters?
                           @service.new.call(data)
                         else
                           @service.new.call
                         end
      result = T.let(service_response.serialize_to(:json), Typed::Result[T::Struct, T.untyped])
      if result.failure?
        response.status = 422
        response.write(JSON.dump({ errors: result.error }))
      end
      response.write(result.payload)
      response
    end

    private

    def parse_body(_body)
      {}
    end

    def parse_query_string(querystring)
      return {} if querystring.empty?

      querystring.split("&").map do |param_pair|
        pair_array = param_pair.split("=")
        pair_array << nil if pair_array.count == 1
        pair_array
      end.to_h
    end

    def populate_data_from(params); end

    sig { returns(T::Boolean) }
    def uses_parameters?
      @uses_parameters ||= !signature.parameters.empty?
    end

    def signature
      @signature ||= T::Utils.signature_for_method(@service.instance_method(:call))
    end
  end
end
