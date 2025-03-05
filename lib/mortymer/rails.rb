# frozen_string_literal: true

require "mortymer/rails/configuration"
require "mortymer/rails/endpoint_wrapper_controller"
require "mortymer/rails/routes"

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
