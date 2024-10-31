# frozen_string_literal: true

require_relative "../../lib/morty"

Morty::Loader.load_services("#{Dir.pwd}/api")
run Morty::App.new
