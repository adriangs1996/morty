# frozen_string_literal: true

module Morty
  # A base model for defining schemas
  class Model < Dry::Struct
    include Dry.Types()
  end
end
