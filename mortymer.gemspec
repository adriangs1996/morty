# frozen_string_literal: true

require_relative "lib/mortymer/version"

Gem::Specification.new do |spec|
  spec.name = "mortymer"
  spec.version = Mortymer::VERSION
  spec.authors = ["Adrian Gonzalez"]
  spec.email = ["adriangonzalezsanchez1996@gmail.com"]

  spec.summary = "A really simple DSL for writing API endpoints with openapi support"
  spec.description = "A simple DSL to describe metadata for endpoints and automatic params construction based on dry-struct schemas. Support for openapi"
  spec.homepage = "https://github.com/adriangs1996/morty"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = "https://adriangs1996.github.io/morty/"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-struct", "~> 1.8"
  spec.add_dependency "dry-swagger", "~> 2.0"
  spec.add_dependency "dry-validation", "~> 1.11"
  spec.add_dependency "sorbet-runtime", "~> 0.5.12026"

  spec.add_development_dependency "rails", "~> 8.0"
end
