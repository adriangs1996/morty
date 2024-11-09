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
  module AppDependency
    interface!

    sig { abstract.params(request: T.nilable(Rack::Request)).void }
    def build(request = nil); end
  end
end
