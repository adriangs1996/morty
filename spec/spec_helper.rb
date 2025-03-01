# frozen_string_literal: true

require "rspec"
require "morty"
require_relative "support/test_classes"

# Add presence check for Hash and Array
class Hash
  def present?
    !empty?
  end
end

# Monkey patch array
class Array
  def present?
    !empty?
  end
end

# Monkey patch object
class Object
  def present?
    !nil?
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
