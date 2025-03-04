# API Metadata

The `ApiMetadata` module is a core component of Morty that allows you to define and configure API endpoints in your Ruby classes. It provides a clean DSL for declaring HTTP endpoints with their input/output types and automatically handles endpoint registration and Rails integration.

## Basic Usage

Include the `ApiMetadata` module in your endpoint classes to use the DSL:

```ruby
class UserEndpoint
  include Morty::ApiMetadata

  # Define a GET endpoint
  get input: UserSearchInput,
      output: UserSearchOutput

  def call(input)
    # Your endpoint logic here
    UserSearchOutput.new(...)
  end
end
```

## HTTP Method DSL

The module provides methods for all common HTTP verbs:

- `get(input:, output:, path: nil)`
- `post(input:, output:, path: nil)`
- `put(input:, output:, path: nil)`
- `delete(input:, output:, path: nil)`

Each method accepts:

- `input`: The class that defines the input schema/parameters
- `output`: The class that defines the response schema
- `path`: Optional custom path override (defaults to convention-based routing)

## Method Names

By default, Morty looks for either a `call` or `execute` method as the endpoint handler. You can use other method names, but the endpoint name will include the method name in its registration:

```ruby
class UserEndpoint
  include Morty::ApiMetadata

  # Registers as "UserEndpoint"
  get input: SearchInput, output: SearchOutput
  def call(input)
    # ...
  end

  # Registers as "UserEndpoint#search"
  get input: SearchInput, output: SearchOutput
  def search(input)
    # ...
  end
end
```

## Rails Integration

When used in a Rails application with `config.morty.wrap_methods` enabled, the module automatically:

1. Wraps endpoint methods to handle parameter conversion
2. Transforms Rails params into your input class
3. Renders JSON responses with proper status codes

This means your endpoint methods can focus purely on business logic while Morty handles the HTTP/Rails integration.

## OpenAPI Generation

Endpoints defined with ApiMetadata automatically participate in OpenAPI documentation generation. The input and output classes are used to generate request/response schemas, and the HTTP method and path information is used to generate path documentation.

See the [OpenAPI Documentation](../advanced/openapi.md) section for more details on how Morty generates API documentation.

## Best Practices

1. Keep endpoint classes focused on a single resource or concern
2. Use meaningful input/output class names that reflect their purpose
3. Consider using namespaces to organize related endpoints
4. Let Morty handle the Rails integration rather than mixing Rails-specific code in your endpoints

## Example

Here's a complete example showing various features:

```ruby
module API
  module V1
    class UsersEndpoint
      include Morty::ApiMetadata

      # GET /api/v1/users
      get input: Users::ListInput, output: Users::ListOutput
      def list(input)
        users = User.limit(input.limit).offset(input.offset)
        Users::ListOutput.new(users: users)
      end

      # POST /api/v1/users
      post input: Users::CreateInput, output: Users::CreateOutput
      def create(input)
        user = User.create!(input.to_h)
        Users::CreateOutput.new(user: user)
      end

      # Custom path example
      # PUT /api/v1/users/:id/activate
      put input: Users::ActivateInput,
          output: Users::ActivateOutput,
          path: '/api/v1/users/:id/activate'
      def activate(input)
        user = User.find(input.id)
        user.activate!
        Users::ActivateOutput.new(user: user)
      end
    end
  end
end
```
