# frozen_string_literal: true

require "dry/swagger/documentation_generator"
require_relative "moldeable"

module Mortymer
  # A base model for defining schemas
  class Model < Dry::Struct
    include Mortymer::Moldeable
    include Dry.Types()

    def self.json_schema
      Dry::Swagger::DocumentationGenerator.new.from_struct(self)
    end

    def self.structify(params)
      new(params)
    end
  end
end
