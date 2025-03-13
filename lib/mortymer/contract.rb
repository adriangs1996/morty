# frozen_string_literal: true

require_relative "moldeable"
require "dry/validation"
require "dry/validation/contract"
require_relative "generator"

module Mortymer
  # A base model for defining schemas
  class Contract < Dry::Validation::Contract
    include Mortymer::Moldeable

    # Exception raised when an error occours in a contract
    class ContractError < StandardError
      attr_reader :errors

      def initialize(errors)
        super
        @errors = errors
      end
    end

    def self.json_schema
      Generator.new.from_validation(self)
    end

    def self.structify(params)
      result = new.call(params)
      raise ContractError.new(result.errors.to_h) unless result.errors.empty?

      result.to_h
    end
  end
end
