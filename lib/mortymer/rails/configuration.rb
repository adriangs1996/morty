# frozen_string_literal: true

module Mortymer
  module Rails
    # A configuration api for Rails & Morty integration
    class Configuration
      attr_accessor :base_controller_class, :error_handler, :wrap_methods

      def initialize
        @base_controller_class = "ApplicationController"
        @error_handler = ->(error) { raise error }
        @wrap_methods = true
      end
    end
  end
end
