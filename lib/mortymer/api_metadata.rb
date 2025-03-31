# frozen_string_literal: true

require_relative "dry_swagger"
require_relative "endpoint_registry"
require_relative "endpoint"
require_relative "utils/string_transformations"
require_relative "sigil"

module Mortymer
  # Include this module in your classes to register
  # and configure your classes as API endpoints.
  module ApiMetadata
    def self.included(base)
      base.include(Sigil)
      base.extend(ClassMethods)
    end

    # The DSL
    module ClassMethods
      def secured_with(security)
        @__endpoint_security__ = security
      end

      def remove_security!
        @__endpoint_security__ = nil
      end

      def tags(*tag_list)
        @__endpoint_tags__ = tag_list
      end

      def __default_tag_for_endpoint__
        # Assuming the endpoint is always defined inside a module
        # the Tag would be the module of that endpoint. If no module, then
        # we take the endpoint and remove any endpoint, controller suffix
        [name.split("::").last(2).first] || [name.gsub(/Controller$/, "").gsub(/Endpoint$/, "")]
      end

      def get(input:, output:, path: nil, security: nil)
        register_endpoint(:get, input, output, path, security || @__endpoint_security__)
      end

      def post(input:, output:, path: nil, security: nil)
        register_endpoint(:post, input, output, path, security || @__endpoint_security__)
      end

      def put(input:, output:, path: nil, security: nil)
        register_endpoint(:put, input, output, path, security || @__endpoint_security__)
      end

      def delete(input:, output:, path: nil, security: nil)
        register_endpoint(:delete, input, output, path, security || @__endpoint_security__)
      end

      # Register an exception handler for the next endpoint
      # @param exception [Class] The exception class to handle
      # @param status [Symbol, Integer] The HTTP status code to return
      # @param output [Class] The output schema class for the error response
      # @yield [exception] Optional block to transform the exception into a response
      # @yieldparam exception [Exception] The caught exception
      # @yieldreturn [Hash] The response body
      def handles_exception(exception, status: 400, output: nil, &block)
        @__endpoint_exception_handlers__ ||= []
        @__endpoint_exception_handlers__ << {
          exception: exception,
          status: status,
          output: output,
          handler: block
        }
      end

      private

      def method_added(method_name)
        super
        return unless @__endpoint_signature__

        EndpointRegistry.registry << Endpoint.new(**@__endpoint_signature__.merge(
          name: reflect_method_name(method_name), action: method_name
        ))
        input_class = @__endpoint_signature__[:input_class]
        handlers = @__endpoint_signature__[:exception_handlers]
        @__endpoint_signature__ = nil
        return unless defined?(::Rails) && ::Rails.application.config.morty.wrap_methods

        rails_wrap_method_with_no_params_call(method_name, input_class, handlers)
      end

      def rails_wrap_method_with_no_params_call(method_name, _input_class, handlers)
        original_method = instance_method(method_name)
        define_method(method_name) do
          # Delegate input handling and checking to Sigil. It will coerce and
          # validate contracts and structs
          input = params.to_unsafe_h.to_h.deep_transform_keys(&:to_sym)
          output = original_method.bind_call(self, input)
          # Output might not be validated, so if it is a hash, we will simple
          # pass it through, otherwise we will call a to_h method
          if output.respond_to?(:to_h)
            render json: output.to_h, status: :ok
          elsif output.respond_to?(:to_json)
            render json: output.to_json, status: :ok
          else
            render json: output, status: :ok
          end
        rescue StandardError => e
          handler = handlers.find { |h| e.is_a?(h[:exception]) }
          raise unless handler

          response = if handler[:handler]
                       handler[:handler].call(e)
                     else
                       { error: e.message || e.class.name.underscore }
                     end

          render json: response, status: handler[:status]
        end
      end

      def register_endpoint(http_method, input_class, output_class, path, security)
        sign input_class, returns: output_class
        @__endpoint_signature__ =
          {
            http_method: http_method,
            input_class: input_class,
            output_class: output_class,
            path: path,
            controller_class: self,
            security: security,
            tags: @__endpoint_tags__ || __default_tag_for_endpoint__,
            exception_handlers: [*(@__endpoint_exception_handlers__ || [])]
          }
        @__endpoint_exception_handlers__ = nil
      end

      def reflect_method_name(method_name)
        if %i[call execute].include?(method_name)
          name
        else
          "#{name}##{method_name}"
        end
      end
    end
  end
end
