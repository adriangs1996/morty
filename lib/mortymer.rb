# frozen_string_literal: true
# typed: true

require "dry/struct"
require "dry/schema"
Dry::Schema.load_extensions(:json_schema)
require "mortymer/types"
require "mortymer/uploaded_file"
require "mortymer/uploaded_files"
require "mortymer/configuration"
require "mortymer/moldeable"
require "mortymer/model"
require "mortymer/contract"
require "mortymer/endpoint"
require "mortymer/dry_swagger"
require "mortymer/endpoint_registry"
require "mortymer/utils/string_transformations"
require "mortymer/sorbet"
require "mortymer/api_metadata"
require "mortymer/openapi_generator"
require "mortymer/container"
require "mortymer/dependencies_dsl"
require "mortymer/security_schemes"
require "mortymer/struct_compiler"
require "mortymer/sigil"
require "mortymer/rails" if defined?(Rails)
require "mortymer/railtie" if defined?(Rails::Railtie)
