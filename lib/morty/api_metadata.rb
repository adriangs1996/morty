# frozen_string_literal: true

require_relative "dry_swagger"
require_relative "endpoint_registry"
require_relative "endpoint"
require_relative "utils/string_transformations"

module Morty
  # Include this module in your classes to register
  # and configure your classes as API endpoints.
  module ApiMetadata
    def self.included(base)
      base.extend(ClassMethods)
    end

    # The DSL
    module ClassMethods
      def get(input:, output:, path: nil)
        register_endpoint(:get, input, output, path)
      end

      def post(input:, output:, path: nil)
        register_endpoint(:post, input, output, path)
      end

      def put(input:, output:, path: nil)
        register_endpoint(:put, input, output, path)
      end

      def delete(input:, output:, path: nil)
        register_endpoint(:delete, input, output, path)
      end

      private

      def method_added(method_name)
        super
        return unless @__endpoint_signature__

        EndpointRegistry.registry << Endpoint.new(**@__endpoint_signature__.merge(
          name: reflect_method_name(method_name), action: method_name
        ))
      end

      def register_endpoint(http_method, input_class, output_class, path)
        @__endpoint_signature__ =
          {
            http_method: http_method,
            input_class: input_class,
            output_class: output_class,
            path: path,
            controller_class: self
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
