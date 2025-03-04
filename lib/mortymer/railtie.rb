# frozen_string_literal: true

require_relative "rails/routes"
require_relative "rails/configuration"
require_relative "rails/endpoint_wrapper_controller"

module Mortymer
  class Railtie < ::Rails::Railtie
    config.morty = Mortymer::Rails::Configuration.new

    initializer "mortymer.initialize" do |app|
    end
  end
end
