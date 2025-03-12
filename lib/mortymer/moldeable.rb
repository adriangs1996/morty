# frozen_string_literal: true

module Mortymer
  # Interface for models to be able to be documentable
  # and buildable from request inputs
  module Moldeable
    def self.json_schema
      raise NotImplementedError
    end

    def self.structify(params = {})
      raise NotImplementedError
    end
  end
end
