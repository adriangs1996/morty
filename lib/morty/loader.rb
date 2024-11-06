# frozen_string_literal: true

module Morty
  # An utility loader
  class Loader
    def self.load_services(path = "api")
      Dir["#{path}/**/*.rb"].sort.each do |f|
        require_relative(f)
      end
    end
  end
end
