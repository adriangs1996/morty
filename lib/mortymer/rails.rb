# frozen_string_literal: true

require "morty/rails/configuration"
require "morty/rails/endpoint_wrapper_controller"
require "morty/rails/routes"

module Mortymer
  module Rails
    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end
  end
end
