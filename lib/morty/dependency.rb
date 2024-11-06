# frozen_string_literal: true
# typed: true

module Morty
  # Declare dependencies for morty applications
  class Dependency
    def self.register(interface, concrete)
      registry[interface] = concrete
    end

    def self.registry
      @registry ||= {}
    end
  end

  # This class defines a dependency for web base apps
  class AppDependency
    sig { void }
    def build; end

    sig { params(request: T.nilable(Rack::Request)).void }
    def initialize(request)
      @request = request
    end
  end
end
