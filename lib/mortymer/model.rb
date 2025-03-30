# frozen_string_literal: true

require "dry/swagger/documentation_generator"
require_relative "moldeable"
require_relative "types"
require_relative "generator"

module Mortymer
  # A base model for defining schemas
  class Model < Dry::Struct
    include Mortymer::Moldeable
    include Mortymer::Types

    def self.json_schema
      Generator.new.from_struct(self)
    end

    def self.structify(params)
      new(params)
    end
  end
end
