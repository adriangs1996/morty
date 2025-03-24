# Dependency Injection

## What is Dependency Injection?

Dependency Injection (DI) is a design pattern that implements Inversion of Control (IoC) for managing dependencies between components.
Instead of having your components create or find their dependencies, these dependencies are "injected" into the component from the outside.

Consider this example without dependency injection:

```ruby
class UserService
  def initialize
    @repository = UserRepository.new
    @mailer = UserMailer.new
  end

  def create_user(params)
    user = @repository.create(params)
    @mailer.send_welcome_email(user)
    user
  end
end
```

In the above code, UserService explicitly creates instances of UserRepository and UserMailer,
making it tightly coupled to these dependencies. When arguing why DI is usefull, commonly
the following arguments arise:

- <b>Harder to Test</b>: We cannot easily substitute UserRepository or UserMailer with mocks or stubs during testing.
  This is not entirely true, as in Ruby you can mock pretty much everything, so this does not make a really good
  argument, although mocking becomes easier when using DI.

- <b>Less Flexible</b>: If we later decide to use a different repository or mailer, we must modify UserService directly.
  Think if we have two implementations of UserMailer, for some reason you want to send emails using SendGrid, but other times
  you want to send emails using your cloud provider solution, or your custom server. UserService really does not cares
  about how this is implemented or where the emails goes, it just need to send an email for whatever channel we choose.

- <b>Tightly Coupled</b>: UserService is responsible for constructing its dependencies, making it harder to manage and extend.

A DI-based approach improves flexibility and testability:

```ruby
class UserService
  def initialize(repository:, mailer:)
    @repository = repository
    @mailer = mailer
  end

  def create_user(params)
    user = @repository.create(params)
    @mailer.send_welcome_email(user)
    user
  end
end

# Inject dependencies
repository = UserRepository.new
mailer = UserMailer.new
service = UserService.new(repository, mailer)
```

Now, UserService does not need to know how to instantiate its dependencies. Instead, they are provided externally.

## The Ruby Community’s Perspective on Dependency Injection

Rubyists often prefer simplicity and flexibility, so DI is not as commonly enforced as in other static-typed languages like Java or C#. This is a topic that spans very different point of views. Just to give an example, read the following Reddit thread
<https://www.reddit.com/r/ruby/comments/10x6w8q/dependency_injection/>

It discusses the use of Dependency Injection (DI) in Ruby, particularly within the context of Ruby on Rails (RoR). Several key points emerge from the conversation:

- <b>Testing and Metaprogramming</b>: One user notes that in languages like Java and PHP, DI is often employed to facilitate testing by allowing the injection of mock dependencies. However, in Ruby, the language's metaprogramming capabilities enable developers to mock dependencies directly without the need for DI containers, potentially simplifying the codebase.

- <b>Code Organization and Dependency Tracking</b>: Another perspective suggests that DI serves as a method to organize code systematically and maintain an efficient track of dependencies. Improved testability is viewed as a beneficial byproduct of this organization.

- <b>Coupling and Code Simplicity</b>: It's acknowledged that while avoiding DI can lead to simpler code, it may also result in tighter coupling between components. This necessitates a careful balance to ensure that the code remains maintainable without becoming overly complex.

In summary, the thread reflects a nuanced view within the Ruby community regarding DI. Some developers prefer to leverage Ruby's dynamic features and metaprogramming to manage dependencies, while others advocate for DI as a means to achieve cleaner code organization and dependency management. The choice often depends on the specific requirements and context of the project.

## The way of Mortymer

I think that DI is necessary, no matter how you decide to handle it. To be aware of
what your functionality depends on is crucial when evaluating the impact of changes. While
testability benefits exist in Ruby through its powerful metaprogramming capabilities, the main
advantage of DI is the explicitness about what your code does and what it depends on. This
transparency makes the code more maintainable and easier to understand.

Additionally, DI naturally supports the Open-Closed Principle (the 'O' in SOLID): when
dependencies are injected rather than hardcoded, new functionality can be added by creating
new implementations of interfaces rather than modifying existing code. While it's technically
possible to extend functionality without DI in Ruby, doing so often requires more complex
metaprogramming or direct code modifications, making the system harder to maintain and understand
over time.

With this in mind, we can explore different approaches to do Dependency Injection in Ruby.

### Constructor Injection

This is by far the most common implementation of DI. This includes initialization of objects
and dependencies are passed as parameters. In ruby, we would do it like:

```ruby
class UserService
  def initialize(repository: UserRepository.new, mailer: UserMailer.new)
    @repository = repository
    @mailer = mailer
  end

  def find_user(user_id)
    # Use @repository and @mailer
  end
end
```

Note how we added a default value to the repository and mailer dependency. This is a convenience
that will let programmers to initialize easily an `UserService` using just the `#new` method
and make it clearer which interface ( any repository we use here must conform to the same interface
as `UserRepository` and the same goes to `UserMailer`)

### Method injection

Passing dependencies directly to a method when needed:

```ruby
class UserService
  def create_user(params, repository: UserRepository.new, mailer: UserMailer.new)
    user = repository.create(params)
    mailer.send_welcome_email(user)
    user
  end
end
```

This approach is less common, but is really useful when you have some classes with different
dependencies for different methods. This is generally easy to avoid tough, by using the Command Pattern
or Service Objects with constructor Injection.

### Global Injection

Global Injection is often used in frameworks like Ruby on Rails,
where dependencies can be globally configured and injected throughout the application.

```ruby
# config/initializers/dependencies.rb
MyAppDependencies = {
  user_repository: UserRepository.new,
  mailer: UserMailer.new
}

# In the service
class UserService
  def initialize(repository: MyAppDependencies[:user_repository], mailer: MyAppDependencies[:mailer])
    @repository = repository
    @mailer = mailer
  end

  def create_user(params)
    user = @repository.create(params)
    @mailer.send_welcome_email(user)
    user
  end
end
```

### Dependency Injection Containers

Gems like dry-container and dry-auto_inject help manage dependencies in larger applications:

```ruby
class UserService
  include Import["repositories.user_repository", "mailers.user_mailer"]

  def create_user(params)
    user = user_repository.create(params)
    user_mailer.send_welcome_email(user)
    user
  end
end
```

This category is where Mortymer fit in. Actually, DI Containers all essentially do the same: to make developer
life easier when declaring and handling this dependencies. For example, the first approach we discuss, **Constructor Injection**,
becomes really tedious to use, there is a lot of boilerplate code to write. Imaging all the time writing the same
initialize function receiving your dependencies and setting the instance variables. Well, gems do exactly that, remove
the boilerplate for you. The main difference is in how they do it and what you get in return. Gems like dry-auto_inject
, like shown above, focus on constants resolutions through strings, and dynamically created read methods for your dependencies.

Mortymer does it in a very different way. We favor dependencies being referenced using constants, because that
empowers code navigation and tools like LSP with go to definitions and such features. Also, referencing constants, allows
us to use a similar API that is found on strongly-typed languages like Java. The other main difference is that Mortymer will
not create methods on the fly for you, you will get instance variables. The same example using Mortymer looks like:

```ruby
class UserService
  include Mortymer::DependenciesDsl

  inject Repositories::UserRepository
  inject Mailers::UserMailer, as: :mailer

  def create_user(params)
    user = @user_repository.create(params)
    @mailer.send_welcome_email(user)
    user
  end
end
```
