# frozen_string_literal: true

module Morty
  # A global registry of all defined endpoints
  class EndpointRegistry
    class << self
      def registry
        @registry ||= []
      end
    end
  end
end
