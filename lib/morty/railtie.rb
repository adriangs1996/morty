# frozen_string_literal: true

require_relative "rails/routes"
require_relative "rails/configuration"
require_relative "rails/endpoint_wrapper_controller"

module Morty
  class Railtie < ::Rails::Railtie
  end
end
