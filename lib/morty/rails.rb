# frozen_string_literal: true

require "morty"
require "morty/rails/engine"
require "morty/rails/controller"
require "morty/rails/routes"
require "morty/rails/configuration"

module Morty
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
