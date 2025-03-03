# frozen_string_literal: true

module Morty
  # A global registry of all defined endpoints
  class EndpointRegistry
    class << self
      def registry
        @registry ||= []
      end

      def get_matcher(path, method)
        @registry.find { |e| e.path.to_s == path.to_s && e.http_method.to_s == method.to_s }
      end
    end
  end
end
