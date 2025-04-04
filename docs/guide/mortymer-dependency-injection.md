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

The name of the injected variable is the snake_case version of the class we are injecting by default. So
for example `Repositories::UserRepository` will result in an instance variable called `@user_repository`

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

Just with the basic information, Mortymer already provides a really powerful and
expressive system to declare dependencies, but as it is, is just a Fancy Factory or Initializer
for your classes. Where Dependency Injection really shines, is when you are able to control some
other aspects of the dependency injection cycle. For example, Mortymer does not interfere with your
usual object initialization.

```ruby
class MyService
  include Mortymer::DependenciesDsl
  inject Mailer

  def initialize(user)
    # At this point we can be sure that the @mailer instance
    # is already defined
    @mailer.send_email("Hello user", user.email)
    @user = user
  end
```

It might not be clear what is happening here. What is really doing Mortymer is
wrapping the `#initialize` method with the dependency resolving algorithm and if
any `kwarg` passed to the `#initialize` method matches the name of the injected
dependency, then Mortymer will use that as the dependency instead.

This means that you can call your previous service as:

```ruby
MyService.new(User.first) # will use the Mailer class to instantiate the @mailer variable
MyService.new(User.first, mailer: instance_double(Mailer))  # will override @mailer with an instance_double
```

### Dependency Scopes

Mortymer supports different scopes for dependencies:

- By default, dependencies are transient, meaning you will get a new fresh instance each time you ask for one
- Dependencies might be singleton, meaning each injection will provide the same instance
- Dependencies might be lazy, basically, a block that might compute a value for your dependency

To change a dependency's scope, you need to register it in the Mortymer DI Container

#### Singleton Scope

```ruby
Mortymer.container.register_constant(Mailer, SingletonMailer.new)
```

#### Lazy Scope

```ruby
Mortymer.container.register_constant(MAILER_ADMIN_ADDRESS) do
  if some_condition?
    "admin+#{Time.current}@example.com"
  else
    "admin-ex@example.com"
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

class UserService
  include Mortymer::DependenciesDsl

  inject UserRepositoryInterface, as: :repo
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
Mortymer.container.register_constant(UserRepositoryInterface, PostgresUserRepository.new)

# Then you can instantiate
UserService.new # will use the PostgresUserRepository implementation
UserService.new(repo: MongoUserRepository.new) # override the dependency to use a different one
```
