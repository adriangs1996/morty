# frozen_string_literal: true

require_relative "lib/morty/version"

Gem::Specification.new do |spec|
  spec.name = "morty"
  spec.version = Morty::VERSION
  spec.authors = ["Adrian Gonzalez"]
  spec.email = ["adriangonzalezsanchez1996@gmail.com"]

  spec.summary = "Yet another attempt to write a ruby web framework."
  spec.description = "A framework designed to build APIs. Is lighter than something like Rails, much like something like Sinatra. Built with full support for sorbet in mind."
  spec.homepage = "https://github.com/adriangs1996/morty"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
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
  spec.add_dependency "sorbet-schema", "~> 0.9.2"
  spec.add_dependency "tapioca", "~> 0.16.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
