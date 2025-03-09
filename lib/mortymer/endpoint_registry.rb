# frozen_string_literal: true

module Mortymer
  # A global registry of all defined endpoints
  class EndpointRegistry
    class << self
      def registry
        if defined?(Rails.application) && Rails.application.config.cache_classes == false
          Rails.application.reloader.wrap do
            @registry ||= []
          end
        else
          @registry ||= []
        end
      end

      def get_matcher(path, method)
        registry.find { |e| e.path.to_s == path.to_s && e.http_method.to_s == method.to_s }
      end

      def clear
        @registry = nil
      end
    end
  end
end
