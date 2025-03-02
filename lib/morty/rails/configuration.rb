# frozen_string_literal: true

module Morty
  module Rails
    # A configuration api for Rails & Morty integration
    class Configuration
      attr_accessor :base_controller_class, :error_handler

      def initialize
        @base_controller_class = "ApplicationController"
        @error_handler = ->(error) { raise error }
      end
    end
  end
end
