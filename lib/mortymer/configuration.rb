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
    attr_accessor :container, :serve_swagger, :swagger_title, :swagger_path, :swagger_root, :api_version,
                  :api_description, :security_schemes, :api_prefix

    def initialize
      @container = Mortymer::Container.new
      @serve_swagger = true
      @swagger_title = "Rick & Rails API"
      @swagger_path = "/api-docs/openapi.json"
      @swagger_root = "/api-docs"
      @api_description = "An awsome API developed with MORTYMER"
      @api_version = "v1"
      @security_schemes = {}
      @api_prefix = "/api/v1"
    end
  end
end
