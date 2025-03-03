# frozen_string_literal: true

require "dry_struct_parser/struct_schema_parser"
require "dry_validation_parser/validation_schema_parser"
require "dry/swagger/documentation_generator"
require "dry/swagger/errors/missing_hash_schema_error"
require "dry/swagger/errors/missing_type_error"
require "dry/swagger/config/configuration"
require "dry/swagger/config/swagger_configuration"
require "dry/swagger/railtie" if defined?(Rails)
