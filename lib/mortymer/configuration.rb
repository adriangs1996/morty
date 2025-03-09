# frozen_string_literal: true

module Mortymer
  class << self
    def configure
      yield(config)
    end

    def container
      yield(config.container) if block_given?
      config.container
    end

    def config
      @config ||= Configuration.new
    end
  end

  # Global configuration for Mortymer
  class Configuration
    attr_accessor :container

    def initialize
      @container = Mortymer::Container.new
    end
  end
end
