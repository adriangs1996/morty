# frozen_string_literal: true

require "dry-struct"
require "securerandom"

module Mortymer
  class StructCompiler
    PRIMITIVE_TYPE_MAP = {
      "string" => Mortymer::Model::String,
      "integer" => Mortymer::Model::Integer,
      "number" => Mortymer::Model::Float,
      "boolean" => Mortymer::Model::Bool,
      "null" => Mortymer::Model::Nil,
      string: Mortymer::Model::String,
      integer: Mortymer::Model::Integer,
      number: Mortymer::Model::Float,
      boolean: Mortymer::Model::Bool,
      null: Mortymer::Model::Nil
    }.freeze

    def initialize(class_name = "GeneratedStruct#{SecureRandom.hex(4)}")
      @class_name = class_name
      @types = {}
    end

    def compile(schema)
      build_type(schema, @class_name)
    end

    private

    def build_type(schema, type_name)
      schema = normalize_schema(schema)
      case schema["type"]
      when "object"
        build_object_type(schema, type_name)
      when "array"
        build_array_type(schema)
      else
        build_primitive_type(schema)
      end
    end

    def normalize_schema(schema)
      return {} if schema.nil?

      schema = schema.transform_keys(&:to_s)
      if schema["properties"]
        schema["properties"] = schema["properties"].transform_keys(&:to_s)
        schema["properties"].each_value do |prop_schema|
          normalize_schema(prop_schema)
        end
      end
      schema["items"] = normalize_schema(schema["items"]) if schema["items"]
      schema["required"] = schema["required"].map(&:to_s) if schema["required"]
      if schema["enum"]
        schema["enum"] = schema["enum"].map { |v| v.is_a?(Symbol) ? v.to_s : v }
      end
      schema
    end

    def build_object_type(schema, type_name)
      return {} unless schema["properties"]

      # Build attribute definitions
      attributes = schema["properties"].map do |name, property_schema|
        name = name.to_s # Ensure name is a string
        nested_type_name = camelize("#{type_name}#{camelize(name)}")
        type = if property_schema["type"] == "object"
                 build_type(property_schema, nested_type_name)
               else
                 build_type(property_schema, nil)
               end

        required = schema["required"]&.include?(name)
        [name, required ? type : type.optional, required]
      end

      # Create a new Struct class for this object
      Class.new(Mortymer::Model) do
        attributes.each do |name, type, required|
          if required
            attribute name.to_sym, type
          else
            attribute? name.to_sym, type
          end
        end
      end
    end

    def build_array_type(schema)
      item_type = build_type(schema["items"], nil)
      Mortymer::Model::Array.of(item_type)
    end

    def build_primitive_type(schema)
      type_class = PRIMITIVE_TYPE_MAP[schema["type"]] || Mortymer::Model::Any

      if schema["enum"]
        type_class.enum(*schema["enum"])
      else
        type_class
      end
    end

    def camelize(string)
      string.split(/[^a-zA-Z0-9]/).map(&:capitalize).join
    end
  end
end
