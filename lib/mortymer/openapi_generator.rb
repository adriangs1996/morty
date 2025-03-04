# frozen_string_literal: true

require_relative "endpoint_registry"
require_relative "utils/string_transformations"

module Mortymer
  # Generate an openapi doc based on the registered endpoints
  class OpenapiGenerator
    include Utils::StringTransformations

    def initialize(prefix: "", title: "Rick on Rails API", version: "v1", description: "", registry: [])
      @prefix = prefix
      @title = title
      @version = version
      @description = description
      @endpoints_registry = registry
    end

    def generate
      {
        openapi: "3.0.1",
        info: { title: @title, version: @version, description: @description },
        paths: generate_paths,
        components: { schemas: generate_schemas }
      }
    end

    private

    def generate_paths
      @endpoints_registry.each_with_object({}) do |endpoint, paths|
        next unless endpoint.routeable?

        schema = endpoint.generate_openapi_schema || {}
        schema = schema.transform_keys { |k| @prefix + k }
        paths.merge!(schema)
      end || {}
    end

    def generate_schemas # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      schemas = {
        "Error422" => {
          type: "object",
          required: %w[error details],
          properties: {
            error: {
              type: "string",
              description: "Error type identifier",
              example: "Validation Failed"
            },
            details: {
              type: "string",
              description: "Detailed error message",
              example: 'type_error: ["foo"] is not a valid Integer'
            }
          }
        }
      }

      @endpoints_registry.each do |endpoint|
        next unless endpoint.routeable?

        if endpoint.input_class && !schemas.key?(demodulize(endpoint.input_class.name))
          schemas[demodulize(endpoint.input_class.name)] =
            Dry::Swagger::DocumentationGenerator.new.from_struct(endpoint.input_class)
        end

        if endpoint.output_class && !schemas.key?(demodulize(endpoint.output_class.name))
          schemas[demodulize(endpoint.output_class.name)] =
            Dry::Swagger::DocumentationGenerator.new.from_struct(endpoint.output_class)
        end
      end
      schemas
    end
  end
end
