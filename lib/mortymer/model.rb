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
      if params.instance_of?(self.class)
        params
      else
        call(params)
      end
    end

    def [](key)
      public_send(key)
    end

    def key?(attr)
      attributes.key?(attr.to_sym)
    end

    alias has_key? key?
  end
end
