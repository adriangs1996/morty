# frozen_string_literal: true

require_relative "dry_swagger"
require_relative "endpoint_registry"
require_relative "endpoint"
require_relative "utils/string_transformations"

module Mortymer
  # Include this module in your classes to register
  # and configure your classes as API endpoints.
  module ApiMetadata
    def self.included(base)
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

      private

      def method_added(method_name)
        super
        return unless @__endpoint_signature__

        EndpointRegistry.registry << Endpoint.new(**@__endpoint_signature__.merge(
          name: reflect_method_name(method_name), action: method_name
        ))
        input_class = @__endpoint_signature__[:input_class]
        @__endpoint_signature__ = nil
        return unless defined?(::Rails) && ::Rails.application.config.morty.wrap_methods

        rails_wrap_method_with_no_params_call(method_name, input_class)
      end

      def rails_wrap_method_with_no_params_call(method_name, input_class)
        original_method = instance_method(method_name)
        define_method(method_name) do
          input = input_class.new(params.to_unsafe_h.to_h.deep_transform_keys(&:to_sym))
          output = original_method.bind_call(self, input)
          render json: output.to_h, status: :ok
        end
      end

      def register_endpoint(http_method, input_class, output_class, path, security)
        @__endpoint_signature__ =
          {
            http_method: http_method,
            input_class: input_class,
            output_class: output_class,
            path: path,
            controller_class: self,
            security: security,
            tags: @__endpoint_tags__ || __default_tag_for_endpoint__
          }
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
