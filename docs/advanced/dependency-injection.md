# Dependency Injection

Morty provides a powerful dependency injection system
that helps you write clean, testable code.

## Basic Usage

```ruby
class UserService
  include Morty::DependenciesDsl

  inject EmailService
  inject UserRepository

  def process_user(id)
    user = user_repository.find(id)
    email_service.send_welcome_email(user)
  end
end

```
