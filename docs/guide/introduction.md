# Introduction

Morty is a modern Ruby gem designed to enhance API development
in Ruby on Rails applications. It brings type safety, automatic documentation,
and clean architecture practices to your Rails APIs.

## Features

- **Type-Safe APIs**: Define input and output types for your endpoints
- **Automatic Documentation**: OpenAPI/Swagger documentation generation
- **Clean Architecture**: Dependency injection and clear separation of concerns
- **Rails Integration**: Seamless integration with Ruby on Rails
- **Developer Experience**: Great DX with clear error messages and debugging tools

## Quick Start

### Basic Example

```ruby
# app/endpoints/users/create_endpoint.rb
class Users::CreateEndpoint
  include Morty::ApiMetadata

  # Define the endpoint with input/output types
  post input: CreateUserInput,
       output: UserOutput

  def call(input)
    user = User.create!(
      name: input.name,
      email: input.email
    )

    UserOutput.new(
      id: user.id,
      name: user.name,
      email: user.email
    )
  end
end

# app/types/create_user_input.rb
class CreateUserInput < Morty::Model
  attribute :name, Types::String
  attribute :email, Types::String
end

# app/types/user_output.rb
class UserOutput < Morty::Model
  attribute :id, Types::Integer
  attribute :name, Types::String
  attribute :email, Types::String
end
```

This will automatically:

- Validate input parameters
- Generate OpenAPI documentation
- Create a type-safe API endpoint
- Mount the endpoint in your Rails routes

## Why Morty?

Morty brings the best practices of modern API development to the Ruby ecosystem:

1. **Type Safety**: Catch errors before they reach production
2. **Documentation**: Always up-to-date API documentation
3. **Maintainability**: Clear structure and separation of concerns
4. **Testing**: Easy to test with dependency injection
