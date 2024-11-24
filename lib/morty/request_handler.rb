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
      status_code, body = dispatch(request)
      response.status = status_code
      response.write(body)
      response
    end

    private

    def build_type(type, request)
      concrete_implementation = Dependency.registry[type]
      if concrete_implementation.nil?
        impl = type.new
        impl.build(request) if impl.respond_to?(:build)
        impl
      else
        sign = signature_for_type(concrete_implementation)
        if sign.nil? || sign.empty?
          impl = concrete_implementation.new
          impl.build(request) if impl.respond_to?(:build)
          impl
        else
          params = {}
          sign.each do |name, meta|
            typ = meta[:type]
            concrete = Dependency.registry[typ]
            if concrete.nil?
              params[name] = build_type(typ, request)
            else
              target = concrete.new
              target.build(request) if target.respond_to?(:build)
              params[name] = target
            end
          end
          result = concrete_implementation.new(**params)
          result.build(request) if result.respond_to?(:build)
          result
        end
      end
    end

    def build_service(request)
      if init_signature.nil? || init_signature.empty?
        @service.new
      else
        params = {}
        init_signature.each do |name, meta|
          params[name] = build_type(meta[:type], request)
        end
        @service.new(**params)
      end
    end

    def dispatch(request)
      service = build_service(request)
      service_response = if uses_parameters?
                           pos_args, kwarg_args = data_from_request(request)
                           service.call(*pos_args, **kwarg_args)
                         else
                           service.call
                         end
      if service_response.is_a?(T::Struct) || service_response.is_a?(T::InexactStruct)
        result = service_response.serialize_to(service.__serializer)
        if result.success?
          [service.__status_code, result.payload]
        else
          [422, JSON.dump({ errors: result.error })]
        end
      else
        [service.__status_code, service_response]
      end
    end

    def data_from_request(request)
      request_method = request.request_method&.downcase
      args = parse_path_parameters_if_needed(request)
      if %w[get head delete].include?(request_method)
        populate_data_from(parse_query_string(request.query_string).merge(args))
      else
        body = request.body.read
        body = "{}" if body.empty?
        populate_data_from(parse_query_string(request.query_string).merge(parse_body(body)).merge(args))
      end
    end

    def parse_path_parameters_if_needed(request)
      original_path = @service.__resulting_path
      return {} if original_path.nil? || [original_path, "#{original_path}/"].include?(request.path)

      match = Regexp.new(original_path).match(request.path)
      match&.named_captures || {}
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
          if data.key?(name.to_s)
            result = Typed::Coercion.coerce(type: type, value: data[name.to_s])
            raise BadRequestError.new(result.error.to_json) if result.failure?

            result.payload
          end
        else
          target_type = T.let(type.raw_type, T.untyped)
          # Attempt to deserialize from body
          serializer = Typed::HashSerializer.new(schema: target_type.schema)
          result = serializer.deserialize(data)
          result = serializer.deserialize(data[name.to_s]) if result.failure? && data.key?(name.to_s)
          raise BadRequestError.new(result.error.to_json) if result.failure?

          result.payload
        end
      else
        # This is probably a nilable case
        possible_types = type.types.map do |try_type|
          use_type = T.let(try_type.raw_type, T.untyped)
          if [Integer, Float, String, T::Boolean, Symbol, TrueClass, FalseClass].include? use_type
            use_type = T::Boolean if [TrueClass, FalseClass].include? use_type
            Typed::Coercion.coerce(type: use_type, value: data[name.to_s]) if data.key?(name.to_s)
          else
            # Attempt to deserialize from body
            r = Typed::HashSerializer.new(schema: use_type.schema).deserialize(data)
            if r.failure? && data.key?(name.to_s)
              r = Typed::HashSerializer.new(schema: use_type.schema).deserialize(data[name.to_s])
            end
            r
          end
        end
        res = possible_types.select(&:success?).first&.payload
        return res unless res.nil?

        errs = {}
        possible_types.select(&:failure?).each do |failure|
          errs.merge!(failure.error)
        end
        raise BadRequestError.new(errs.to_json)
      end
    end

    sig { returns(T::Boolean) }
    def uses_parameters?
      @uses_parameters ||= !signature.parameters.empty?
    end

    def signature_for_type(type)
      type.props if type.respond_to?(:props)
    end

    def init_signature
      @init_signature ||= (@service.props if @service.respond_to?(:props))
    end

    def signature
      @signature ||= T::Utils.signature_for_method(@service.instance_method(:call))
    end
  end
end
