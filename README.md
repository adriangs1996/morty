# Morty

```markdown
███╗   ███╗ ██████╗ ██████╗ ████████╗██╗   ██╗
████╗ ████║██╔═══██╗██╔══██╗╚══██╔══╝╚██╗ ██╔╝
██╔████╔██║██║   ██║██████╔╝   ██║    ╚████╔╝ 
██║╚██╔╝██║██║   ██║██╔══██╗   ██║     ╚██╔╝  
██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║      ██║   
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   
```

Morty is a Ruby gem that simplifies API endpoint management and documentation for Ruby on Rails applications. It provides a clean DSL for defining API endpoints with input/output contracts and automatically generates OpenAPI documentation.

[![Gem Version](https://badge.fury.io/rb/morty.svg)](https://badge.fury.io/rb/morty)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🚀 Simple DSL for defining API endpoints
- 📝 Automatic OpenAPI documentation generation
- ✨ Input/Output contract validation
- 🎯 Dependency injection support
- 🛣️ Seamless Rails integration

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'morty'
```

And then execute:

```bash
bundle install
```

## Usage

### Basic Example

```ruby
class UserProfileEndpoint < ApplicationController
  include Morty::ApiMetadata

  # Define an endpoint with input/output contracts
  get input: UserProfileInput, output: UserProfileOutput, path: '/api/v1/users/:id/profile'
  def call(input)
    user = User.find(input.id)
    UserProfileOutput.new(
      id: user.id,
      name: user.name,
      email: user.email
    )
  end
end
```

### Input/Output Contracts

```ruby
class UserProfileInput < Morty::Model
  attribute :id, Types::Integer
  attribute :include_details, Types::Bool.optional.default(false)
end

class UserProfileOutput < Morty::Model
  attribute :id, Types::Integer
  attribute :name, Types::String
  attribute :email, Types::String
end
```

### Dependency Injection

```ruby
class UserService
  include Morty::DependenciesDsl

  # Inject dependencies
  inject UserRepository
  inject EmailService, as: :mailer

  def process_user(id)
    user = @user_repository.find_user(id)
    @email_service.send_email(user.email, "Welcome!")
  end
end
```

### Rails Integration

In your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  Morty::Rails::Routes.new(self).mount_controllers
end
```

## OpenAPI Documentation

Morty automatically generates OpenAPI documentation for your API endpoints. The documentation includes:

- Endpoint paths and HTTP methods
- Request/response schemas
- Input validation rules
- Error responses

To generate the OpenAPI documentation:

```ruby
generator = Morty::OpenapiGenerator.new(
  prefix: "/api",
  title: "My API",
  version: "v1"
)
generator.generate
```

## Contributing

We love your input! We want to make contributing to Morty as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

### Development Process

1. Fork the repo and create your branch from `master`
2. If you've added code, please, add some tests to contribute to gem health
3. If you've changed APIs, update the documentation accordingly
4. Ensure the test suite passes
5. Make sure your code lints
6. Issue that pull request!

### Running Tests

```bash
bundle install
bundle exec rspec
```

## License

MIT License. See [LICENSE](LICENSE) for details.

## Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/0/code_of_conduct/) Code of Conduct.

## Support

If you have any questions or need help with Morty:

- Open an [issue](https://github.com/yourusername/morty/issues)
- Join our [Discord community](#) (coming soon)

## Credits

Morty is maintained by [Adrian Gonzalez] and was inspired by the need for a simple,
yet powerful API management solution in the Ruby ecosystem, that integrates well
with existing frameworks. We deserve a FastAPI experience within the ruby side.
