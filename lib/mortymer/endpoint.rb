# frozen_string_literal: true

module Mortymer
  # Represents an endpoint in a given system
  class Endpoint
    attr_reader :http_method, :path, :input_class, :output_class, :controller_class, :action, :name

    def initialize(opts = {})
      @http_method = opts[:http_method]
      @input_class = opts[:input_class]
      @output_class = opts[:output_class]
      @name = opts[:name]
      @path = opts[:path] || infer_path_from_class
      @controller_class = opts[:controller_class]
      @action = opts[:action]
      @security = opts[:security]
    end

    def routeable?
      [@input_class, @http_method, @output_class, @path].none?(&:nil?)
    end

    def api_name
      Utils::StringTransformations.underscore(name.gsub("::", "/")).gsub(/_endpoint$/, "").split("#").first
    end

    def controller_name
      Utils::StringTransformations.underscore(@name.split("#").first.split("::").join("/"))
    end

    def infer_path_from_class
      # Remove 'Endpoint' suffix if present and convert to path
      "/" + @name.split("#").first.split("::").map do |s|
        Utils::StringTransformations.underscore(s).gsub(/_endpoint$/, "").gsub(/_controller$/, "")
      end.join("/")
    end

    def generate_openapi_schema # rubocop:disable Metrics/MethodLength
      return unless defined?(@input_class) && defined?(@output_class)

      input_schema = @input_class.respond_to?(:json_schema) ? @input_class.json_schema : Dry::Swagger::DocumentationGenerator.new.from_struct(@input_class)
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

      operation = {
        operation_id: operation_id,
        parameters: generate_parameters,
        requestBody: generate_request_body,
        responses: responses
      }
      operation[:security] = security if @security
      {
        path.to_s => {
          http_method.to_s => operation
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

    def security
      return [] if @security.nil?

      return [{ @security => [] }] if @security.is_a?(Symbol)

      return [@security.scheme] if @security.respond_to?(:scheme)

      [@security]
    end

    def generate_parameters
      return [] unless @input_class && %i[get delete].include?(@http_method)

      schema = if @input_class.respond_to?(:json_schema)
                 @input_class.json_schema
               else
                 Dry::Swagger::DocumentationGenerator.new.from_struct(@input_class)
               end
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

      "#{names_map[@http_method]}_#{controller_name.split("/").last.gsub(/_controller$/, "")}"
    end
  end
end
