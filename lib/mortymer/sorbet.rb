# frozen_string_literal: true

require "sorbet-runtime"
require_relative "moldeable"
require "byebug"

module Mortymer
  # This module provides integration with Sorbet if it is available.
  # It enables Sorbet types to be converted to JSON schema definitions,
  # allowing for seamless integration between Sorbet type checking and
  # JSON schema validation.
  module Sorbet
  end
end

# Extension to the String class to provide JSON schema definition
class String
  # Returns the JSON schema definition for String type
  # @return [Hash] JSON schema definition with type: :string
  def self.json_schema
    { type: :string }
  end
end

# Extension to the Symbol class to provide JSON schema definition
class Symbol
  # Returns the JSON schema definition for Symbol type
  # @return [Hash] JSON schema definition with type: :string
  def self.json_schema
    { type: :string }
  end
end

# Extension to the Integer class to provide JSON schema definition
class Integer
  # Returns the JSON schema definition for Integer type
  # @return [Hash] JSON schema definition with type: :integer
  def self.json_schema
    { type: :integer }
  end
end

# Extension to the Float class to provide JSON schema definition
class Float
  # Returns the JSON schema definition for Float type
  # @return [Hash] JSON schema definition with type: :float
  def self.json_schema
    { type: :float }
  end
end

# Extension to the DateTime class to provide JSON schema definition
class DateTime
  # Returns the JSON schema definition for DateTime type
  # @return [Hash] JSON schema definition with type: :string and format: :datetime
  def self.json_schema
    { type: :string, format: :datetime }
  end
end

# Extension to the Date class to provide JSON schema definition
class Date
  # Returns the JSON schema definition for Date type
  # @return [Hash] JSON schema definition with type: :string and format: :date
  def self.json_schema
    { type: :string, format: :date }
  end
end

# Extension to the Time class to provide JSON schema definition
class Time
  # Returns the JSON schema definition for Time type
  # @return [Hash] JSON schema definition with type: :string and format: :time
  def self.json_schema
    { type: :string, format: :time }
  end
end

# Extension to the File class to provide JSON schema definition
class File
  # Returns the JSON schema definition for File type
  # @return [Hash] JSON schema definition with type: :string and format: :binary
  def self.json_schema
    { type: :string, format: :binary }
  end
end

# Mapping of Sorbet types to their corresponding JSON schema definitions
# Used for types that don't have a direct Ruby class equivalent
TYPE_MAPS = {
  T::Boolean => { type: :boolean }
}.freeze

module T
  module Types
    # Extension to Sorbet's Simple type to provide JSON schema definition
    class Simple
      # Returns the JSON schema definition for a Simple type
      # Looks up the raw type in TYPE_MAPS or delegates to the raw type's json_schema method
      # @return [Hash] JSON schema definition for the simple type
      def json_schema
        TYPE_MAPS.fetch(raw_type) do
          if raw_type.respond_to?(:json_schema)
            raw_type.json_schema
          else
            {}
          end
        end
      end
    end

    # Extension to Sorbet's TypedArray type to provide JSON schema definition
    class TypedArray
      # Returns the JSON schema definition for an array type
      # Creates an array schema with items matching the element type's schema
      # @return [Hash] JSON schema definition with type: :array and appropriate items schema
      def json_schema
        { type: :array, items: type.json_schema }
      end
    end
  end

  # Implements the moldeable interface for Mortymer
  # This allows seamless integration between Sorbet's T::Struct classes
  # and the Mortymer gem's functionality.
  class InexactStruct
    include Mortymer::Moldeable

    # Generates a JSON schema definition for the struct
    # The schema includes:
    # - All properties with their types
    # - Required properties (those without defaults or factories)
    # - Nullable properties (those marked as T.nilable)
    #
    # @return [Hash] A JSON schema object with type, properties, and required fields
    # rubocop:disable Metrics/MethodLength
    def self.json_schema
      schema = { type: :object, properties: {}, required: [] }
      props.each do |property, metadata|
        type = metadata[:type]
        property_schema = if type.respond_to?(:json_schema)
                            type.json_schema
                          else
                            TYPE_MAPS.fetch(type, {})
                          end
        optional = metadata.key?(:default) || metadata.key?(:factory)
        property_schema = property_schema.merge(nullable: metadata.key?(:_tnilable))
        schema[:properties][property] = property_schema
        schema[:required] << property unless optional
      end
      schema
    end
    # rubocop:enable Metrics/MethodLength

    # Creates a new instance of the struct from the given parameters
    # @param params [Hash] The parameters to initialize the struct with
    # @return [T::InexactStruct] A new instance of the struct
    def self.structify(params)
      new(params)
    end
  end
end
