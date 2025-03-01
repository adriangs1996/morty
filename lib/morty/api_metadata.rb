# frozen_string_literal: true

require_relative "dry_swagger"
require_relative "endpoint_registry"
require_relative "utils/string_transformations"

module Morty
  # Include this module in your classes to register
  # and configure your classes as API endpoints.
  module ApiMetadata
    def self.included(base)
      base.extend(ClassMethods)
    end

    # The DSL
    module ClassMethods # rubocop:disable Metrics/ModuleLength
      attr_reader :http_method, :path, :input_class, :output_class

      def get(input:, output:, path: nil)
        @http_method = :get
        @path = path || infer_path_from_class
        @input_class = input
        @output_class = output
        EndpointRegistry.registry << self
      end

      def post(input:, output:, path: nil)
        @http_method = :post
        @path = path || infer_path_from_class
        @input_class = input
        @output_class = output
        EndpointRegistry.registry << self
      end

      def put(input:, output:, path: nil)
        @http_method = :put
        @path = path || infer_path_from_class
        @input_class = input
        @output_class = output
        EndpointRegistry.registry << self
      end

      def delete(input:, output:, path: nil)
        @http_method = :delete
        @path = path || infer_path_from_class
        @input_class = input
        @output_class = output
        EndpointRegistry.registry << self
      end

      def routeable?
        [@input_class, @http_method, @output_class, @path].none?(&:nil?)
      end

      def api_name
        name.gsub("::", "/").downcase.gsub(/endpoint$/, "")
      end

      def controller_name
        Utils::StringTransformations.underscore(name.split("::").last).gsub(/_controller$/, "").gsub(/_endpoint$/, "")
      end

      def infer_path_from_class
        # Remove 'Endpoint' suffix if present and convert to path
        "/" + Utils::StringTransformations.underscore(name) # rubocop:disable Style/StringConcatenation
                                          .gsub(/_endpoint$/, "")      # Remove 'Endpoint' suffix
                                          .gsub(/_controller$/, "")    # Remove any '_controller' suffix
                                          .gsub(%r{^/}, "") # Remove leading slash if present
                                          .gsub(%r{^/}, "") # Remove leading slash if present
      end

      def generate_openapi_schema # rubocop:disable Metrics/MethodLength
        return unless defined?(@input_class) && defined?(@output_class)

        input_schema = Dry::Swagger::DocumentationGenerator.new.from_struct(@input_class)
        responses = {
          "200" => {
            description: "Successful response",
            content: {
              "application/json" => {
                schema: class_ref(@output_class)
              }
            }
          }
        }

        # Add 422 response if there are required properties or non-string types that need coercion
        if validations?(input_schema)
          responses["422"] = {
            description: "Validation Failed - Invalid parameters or coercion error",
            content: {
              "application/json": {
                schema: error422_ref
              }
            }
          }
        end

        {
          path.to_s => {
            http_method.to_s => {
              operation_id: operation_id,
              parameters: generate_parameters,
              requestBody: generate_request_body,
              responses: responses
            }
          }
        }
      end

      private

      def validations?(schema)
        return false unless schema

        # Check if there are any required properties
        has_required = schema[:required]&.any?

        # Check if there are any properties that need type coercion (non-string types)
        has_coercions = schema[:properties]&.any? do |_, property|
          type = property[:type]
          type && type != "string" # Any non-string type will need coercion
        end

        has_required || has_coercions
      end

      def generate_parameters
        return [] unless @input_class && %i[get delete].include?(@http_method)

        schema = Dry::Swagger::DocumentationGenerator.new.from_struct(@input_class)
        schema[:properties]&.map do |name, property|
          {
            name: name,
            in: "query",
            schema: property,
            required: schema[:required]&.include?(name)
          }
        end || []
      end

      def generate_request_body
        return unless @input_class && %i[post put].include?(@http_method)

        {
          required: true,
          content: {
            "application/json" => {
              schema: class_ref(@input_class)
            }
          }
        }
      end

      def class_ref(klass)
        { "$ref": "#/components/schemas/#{klass.name.split("::").last}" }
      end

      def error422_ref
        { "$ref": "#/components/schemas/Error422" }
      end

      def operation_id
        names_map = {
          post: :create,
          put: :update,
          delete: :destroy,
          get: :get
        }

        "#{names_map[@http_method]}_#{controller_name}"
      end
    end
  end
end
