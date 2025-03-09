# frozen_string_literal: true

module Mortymer
  module Rails
    # A configuration api for Rails & Morty integration
    class Configuration
      attr_accessor :base_controller_class, :error_handler, :wrap_methods, :container, :api_title, :api_version,
                    :api_description

      def initialize
        @base_controller_class = "ApplicationController"
        @error_handler = ->(error) { raise error }
        @wrap_methods = true
        @container = Mortymer::Container.new

        # API documentation defaults
        @api_title = "Rick on Rails API"
        @api_version = "v1"
        @api_description = ""
      end
    end
  end
end
