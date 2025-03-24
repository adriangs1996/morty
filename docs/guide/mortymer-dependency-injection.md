# Mortymer Dependency Injection Guide

## Overview

Mortymer provides a powerful yet simple dependency injection system that favors explicit constant references and instance variables over dynamic method creation. This guide will walk you through the various ways to use dependency injection with Mortymer.

## Basic Usage

### Simple Injection

The most basic form of dependency injection in Mortymer uses the `inject` directive:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository

  def find_user(id)
    @user_repository.find(id)
  end
end
```

When you include `Mortymer::DependenciesDsl`, you get access to the `inject` directive. This will:

1. Create an instance variable `@user_repository`
2. Automatically initialize it with an instance of `UserRepository`

### Custom Variable Names

You can customize the instance variable name using the `as` option:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository, as: :users

  def find_user(id)
    @users.find(id)
  end
end
```

### Multiple Dependencies

You can inject multiple dependencies in a single class:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository
  inject UserMailer
  inject Logger, as: :logger

  def create_user(params)
    @logger.info("Creating new user")
    user = @user_repository.create(params)
    @user_mailer.send_welcome_email(user)
    user
  end
end
```

## Advanced Usage

### Dependency Scopes

Mortymer supports different scopes for dependencies:

#### Singleton Scope (Default)

By default, dependencies are singleton-scoped, meaning the same instance is shared across the application:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository # Singleton by default
end
```

#### Request Scope

For dependencies that should be unique per request:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository, scope: :request
end
```

#### Transient Scope

For dependencies that should be newly instantiated every time:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository, scope: :transient
end
```

### Factory Registration

You can register custom factory methods for your dependencies:

```ruby
Mortymer.configure do |config|
  config.register_factory(UserRepository) do
    UserRepository.new(connection: DatabaseConnection.current)
  end
end
```

### Interface-Based Dependencies

Mortymer supports interface-based dependency injection:

```ruby
module UserRepositoryInterface
  def find(id)
    raise NotImplementedError
  end
end

class PostgresUserRepository
  include UserRepositoryInterface
  # implementation
end

class MongoUserRepository
  include UserRepositoryInterface
  # implementation
end

# Register implementation
Mortymer.configure do |config|
  config.register_implementation(UserRepositoryInterface, PostgresUserRepository)
end

class UserService
  include Mortymer::DependenciesDsl

  inject UserRepositoryInterface
end
```

## Testing

### Mocking Dependencies

Mortymer makes it easy to mock dependencies in tests:

```ruby
RSpec.describe UserService do
  let(:repository_mock) { instance_double(UserRepository) }
  let(:mailer_mock) { instance_double(UserMailer) }

  before do
    Mortymer.stub_dependency(UserRepository, repository_mock)
    Mortymer.stub_dependency(UserMailer, mailer_mock)
  end

  it "creates a user" do
    service = UserService.new
    expect(repository_mock).to receive(:create)
    expect(mailer_mock).to receive(:send_welcome_email)

    service.create_user(name: "John")
  end
end
```

### Test-Specific Implementations

You can also register test-specific implementations:

```ruby
class TestUserRepository
  include UserRepositoryInterface

  def initialize
    @users = {}
  end

  def find(id)
    @users[id]
  end
end

RSpec.describe UserService do
  before do
    Mortymer.register_implementation(UserRepositoryInterface, TestUserRepository)
  end
end
```

## Best Practices

### 1. Keep Dependencies Explicit

Always use explicit constant references rather than strings for dependencies:

```ruby
# Good
inject UserRepository

# Avoid
inject "user_repository"
```

### 2. Use Meaningful Names

Choose descriptive names for your dependencies:

```ruby
# Good
inject UserRepository, as: :active_users_repository

# Less Clear
inject UserRepository, as: :repo
```

### 3. Group Related Dependencies

Keep related dependencies together and organize them logically:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  # Authentication dependencies
  inject AuthenticationService
  inject TokenGenerator

  # User management dependencies
  inject UserRepository
  inject UserMailer

  # Logging/Monitoring
  inject Logger
  inject MetricsCollector
end
```

### 4. Interface Segregation

Create focused interfaces for your dependencies:

```ruby
module UserReader
  def find(id); end
  def list; end
end

module UserWriter
  def create(attributes); end
  def update(id, attributes); end
end

class UserRepository
  include UserReader
  include UserWriter
end

class UserService
  include Mortymer::DependenciesDsl

  inject UserReader  # Only inject what you need
end
```

## Common Patterns

### Service Objects

```ruby
class CreateUser
  include Mortymer::DependenciesDsl

  inject UserRepository
  inject UserMailer
  inject UserValidator

  def call(params)
    @user_validator.validate!(params)
    user = @user_repository.create(params)
    @user_mailer.send_welcome_email(user)
    user
  end
end
```

### Decorators

```ruby
class LoggedUserRepository
  include Mortymer::DependenciesDsl

  inject UserRepository
  inject Logger

  def find(id)
    @logger.info("Finding user: #{id}")
    result = @user_repository.find(id)
    @logger.info("Found user: #{result&.id}")
    result
  end
end
```

## Configuration

### Global Configuration

```ruby
Mortymer.configure do |config|
  # Register default implementations
  config.register_implementation(UserRepositoryInterface, PostgresUserRepository)

  # Register factories
  config.register_factory(Logger) do
    Logger.new($stdout).tap do |logger|
      logger.level = Rails.env.production? ? :info : :debug
    end
  end

  # Configure scopes
  config.set_scope(UserSession, :request)
end
```

### Environment-Specific Configuration

```ruby
# config/initializers/mortymer.rb
Mortymer.configure do |config|
  if Rails.env.test?
    config.register_implementation(UserRepositoryInterface, TestUserRepository)
  elsif Rails.env.development?
    config.register_implementation(UserRepositoryInterface, DevUserRepository)
  else
    config.register_implementation(UserRepositoryInterface, ProductionUserRepository)
  end
end
```

## Troubleshooting

### Common Issues

1. **Circular Dependencies**

```ruby
# This will raise a CircularDependencyError
class UserService
  include Mortymer::DependenciesDsl
  inject AccountService
end

class AccountService
  include Mortymer::DependenciesDsl
  inject UserService  # Circular dependency!
end
```

Solution: Refactor to remove the circular dependency or use method injection.

2. **Missing Dependencies**

```ruby
# This will raise a DependencyNotFoundError
class UserService
  include Mortymer::DependenciesDsl
  inject NonExistentService
end
```

Solution: Ensure all dependencies are properly registered or the constants exist.

3. **Scope Conflicts**

```ruby
# This might cause issues
class UserService
  include Mortymer::DependenciesDsl
  inject SessionManager, scope: :request  # Request-scoped
  inject UserRepository  # Singleton-scoped
end
```

Solution: Be careful mixing different scopes and ensure it makes sense for your use case.
