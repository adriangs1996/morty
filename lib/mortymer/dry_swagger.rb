# frozen_string_literal: true

require "dry_struct_parser/struct_schema_parser"
require "dry_validation_parser/validation_schema_parser"
require "dry/swagger/documentation_generator"
require "dry/swagger/errors/missing_hash_schema_error"
require "dry/swagger/errors/missing_type_error"
require "dry/swagger/config/configuration"
require "dry/swagger/config/swagger_configuration"
require "dry/swagger/railtie" if defined?(Rails)

# Need to monkey patch the nominal visitor for dry struct parser
# as it currently does nothing with this field
module DryStructParser
  # Just to monkey patch it
  class StructSchemaParser
    def visit_constructor(node, opts) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      # Handle coercible types which have the form:
      # [:constructor, [[:nominal, [Type, {}]], [:method, Kernel, :Type]]]
      if node[0].is_a?(Array) && node[0][0] == :nominal
        if node[0][1][0] == Mortymer::Types::RackFile
          keys[opts[:key]] = node[0][1][1][:swagger].merge(
            required: opts.fetch(:required, true),
            nullable: opts.fetch(:nullable, false)
          )
          return
        end
        required = opts.fetch(:required, true)
        nullable = opts.fetch(:nullable, false)
        type = node[0][1][0] # Get the type from nominal node
        if PREDICATE_TYPES[type.name.to_sym]
          definition = {
            type: PREDICATE_TYPES[type.name.to_sym],
            required: required,
            nullable: nullable
          }
          definition[:array] = opts[:array] if opts[:array]
          keys[opts[:key]] = definition
          return
        end
      end

      # Fall back to regular visit for other cases
      visit(node[0], opts)
    end
  end
end
