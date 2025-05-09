require "dry/swagger"

module Mortymer
  class Generator < Dry::Swagger::DocumentationGenerator
    SWAGGER_FIELD_TYPE_DEFINITIONS = {
      "string" => { type: :string },
      "integer" => { type: :integer },
      "boolean" => { type: :boolean },
      "float" => { type: :float },
      "decimal" => { type: :string, format: :decimal },
      "datetime" => { type: :string, format: :datetime },
      "date" => { type: :string, format: :date },
      "time" => { type: :string, format: :time },
      "uuid" => { type: :string, format: :uuid },
      "file" => { type: :string, format: :binary }
    }.freeze

    def from_struct(struct)
      generate_documentation(::DryStructParser::StructSchemaParser.new.call(struct).keys)
    end

    def from_validation(validation)
      generate_documentation(::DryValidationParser::ValidationSchemaParser.new.call(validation).keys)
    end

    def generate_documentation(fields)
      documentation = { properties: {}, required: [] }
      fields.each do |field_name, definition|
        documentation[:properties][field_name] = generate_field_properties(definition)
        if definition.is_a?(Hash)
          documentation[:required] << field_name if definition.fetch(:required,
                                                                     true) && @config.enable_required_validation
        elsif definition[0].fetch(:required, true) && @config.enable_required_validation
          documentation[:required] << field_name
        end
      end

      { type: :object, properties: documentation[:properties], required: documentation[:required] }
    end

    def generate_field_properties(definition)
      return generate_for_sti_type(definition) if definition.is_a?(Array)

      documentation = if definition[:type] == "array" || definition[:array]
                        generate_for_array(definition)
                      elsif definition[:type] == "hash"
                        generate_for_hash(definition)
                      else
                        generate_for_primitive_type(definition)
                      end
      if @config.enable_nullable_validation
        documentation.merge(@config.nullable_type => definition.fetch(:nullable, false))
      else
        documentation.merge(@config.nullable_type => true)
      end
    rescue KeyError
      raise Errors::MissingTypeError
    end

    def generate_for_sti_type(definition)
      properties = {}

      definition.each_with_index do |_, index|
        properties["definition_#{index + 1}"] = generate_field_properties(definition[index])
      end

      documentation = {
        type: :object,
        properties: properties,
        example: "Dynamic Field. See Model Definitions"
      }

      if definition[0][:type] == "array"
        definition.each { |it| it[:type] = "hash" }
        documentation[:oneOf] = definition.map { |it| generate_field_properties(it) }
        { type: :array, items: documentation }
      else
        documentation[:oneOf] = definition.map { |it| generate_field_properties(it) }
        documentation
      end
    end

    def generate_for_array(definition)
      items = if array_of_primitive_type?(definition)
                self.class::SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(definition.fetch(:type))
              else
                generate_documentation(definition.fetch(:keys))
              end
      items = if @config.enable_nullable_validation
                items.merge(@config.nullable_type => definition.fetch(:nullable, false))
              else
                items.merge(@config.nullable_type => true)
              end
      { type: :array, items: items }
    end

    def generate_for_hash(definition)
      raise Errors::MissingHashSchemaError unless definition[:keys]

      generate_documentation(definition.fetch(:keys))
    end

    def generate_for_primitive_type(definition)
      documentation = self.class::SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(definition.fetch(:type))
      documentation = documentation.merge(enum: definition.fetch(:enum)) if definition[:enum] && @config.enable_enums
      documentation = documentation.merge(description: definition.fetch(:description)) if definition[:description] &&
                                                                                          @config.enable_descriptions
      documentation
    end

    def array_of_primitive_type?(definition)
      definition[:array] && definition.fetch(:type) != "array"
    end
  end
end
