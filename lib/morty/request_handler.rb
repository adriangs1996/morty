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
      result = dispatch(request)
      if result.failure?
        response.status = 422
        response.write(JSON.dump({ errors: result.error }))
      end
      response.write(result.payload)
      response
    end

    private

    sig { params(request: Rack::Request).returns(Typed::Result[T.any(T::InexactStruct, T::Struct), T.untyped]) }
    def dispatch(request)
      service_response = if uses_parameters?
                           pos_args, kwarg_args = data_from_request(request)
                           @service.new.call(*pos_args, **kwarg_args)
                         else
                           @service.new.call
                         end
      T.let(service_response.serialize_to(:json), Typed::Result[T.any(T::InexactStruct, T::Struct), T.untyped])
    end

    def data_from_request(request)
      request_method = request.request_method&.downcase
      if %w[get head delete].include?(request_method)
        populate_data_from(parse_query_string(request.query_string))
      else
        body = request.body.read
        body = "{}" if body.empty?
        populate_data_from(parse_query_string(request.query_string).merge(parse_body(body)))
      end
    end

    def parse_body(body)
      JSON.parse(body)
    end

    def parse_query_string(querystring)
      return {} if querystring.empty?

      querystring.split("&").map do |param_pair|
        pair_array = param_pair.split("=")
        pair_array << nil if pair_array.count == 1
        pair_array.map { |x| CGI.unescape(x) }
      end.to_h
    end

    def populate_data_from(params)
      kwarg_parameters = {}
      pos_parameters = []
      signature.parameters.each_index do |i|
        param_descr, param_name = signature.parameters[i]
        if %i[opt req].include? param_descr
          _, param_type = signature.arg_types[i]
          value = build_from(params, param_type, param_name)
          pos_parameters << value
        else
          param_type = signature.kwarg_types[param_name]
          kwarg_parameters[param_name] = build_from(params, param_type, param_name)
        end
      end
      [pos_parameters, kwarg_parameters]
    end

    def build_from(data, type, name)
      if type.is_a? T::Types::Simple
        if [Integer, Float, String, T::Boolean, Symbol].include? type.raw_type
          data[name.to_s] if data.key?(name.to_s) && data[name.to_s].is_a?(type.raw_type)
        else
          target_type = T.let(type.raw_type, T.untyped)
          # Attempt to deserialize from body
          serializer = Typed::HashSerializer.new(schema: target_type.schema)
          result = serializer.deserialize(data)
          result = serializer.deserialize(data[name.to_s]) if result.failure? && data.key?(name.to_s)
          result.payload
        end
      else
        # This is probably a nilable case
        target_type = type.raw_a
        if [Integer, Float, String, T::Boolean, Symbol].include? target_type
          data[name.to_s] if data.key?(name.to_s) && data[name.to_s].is_a?(target_type)
          nil
        else
          serializer = Typed::HashSerializer.new(schema: target_type.schema)
          result = serializer.deserialize(data)
          result = serializer.deserialize(data[name.to_s]) if result.failure? && data.key?(name.to_s)
          result.payload
        end
      end
    end

    sig { returns(T::Boolean) }
    def uses_parameters?
      @uses_parameters ||= !signature.parameters.empty?
    end

    def signature
      @signature ||= T::Utils.signature_for_method(@service.instance_method(:call))
    end
  end
end
