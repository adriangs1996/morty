# frozen_string_literal: true

require_relative "rails/routes"
require_relative "rails/configuration"
require_relative "rails/endpoint_wrapper_controller"
require_relative "openapi_generator"

module Mortymer
  class Railtie < ::Rails::Railtie # rubocop:disable Style/Documentation
    config.morty = Mortymer::Rails::Configuration.new

    initializer "mortymer.initialize" do |app|
      # Clear registry on reload in development
      if ::Rails.application.config.cache_classes == false
        app.reloader.before_class_unload do
          Mortymer::EndpointRegistry.clear
        end

        app.reloader.to_prepare do
          # Routes will be remounted as classes are autoloaded
          ::Rails.application.eager_load!

          # Regenerate OpenAPI spec
          generator = Mortymer::OpenapiGenerator.new(
            registry: Mortymer::EndpointRegistry.registry,
            title: Mortymer.config.swagger_title,
            version: Mortymer.config.api_version,
            description: Mortymer.config.api_description
          )

          # Save OpenAPI spec to public directory
          spec_dir = ::Rails.root.join("api-docs")
          FileUtils.mkdir_p(spec_dir)
          File.write(spec_dir.join("openapi.json"), JSON.pretty_generate(generator.generate))

          ::Rails.application.reload_routes!
        end
      end
    end
  end
end
