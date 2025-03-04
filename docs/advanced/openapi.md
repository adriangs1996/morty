# OpenAPI Documentation

Morty automatically generates OpenAPI (Swagger)
documentation from your endpoints and models.

## Basic Configuration

```ruby
# config/initializers/morty.rb
Rails.application.config.morty.configure do |config|
  config.openapi.title = "My API"
  config.openapi.version = "v1"
  config.openapi.description = "API documentation for My Application"
end

```
