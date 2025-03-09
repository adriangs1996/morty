# frozen_string_literal: true

require "dry/struct"
require "mortymer"

# Test classes for dependency injection
class Database
  def query(sql)
    "Result for #{sql}"
  end
end

class MyLogger
  def log(message)
    message
  end
end

class UserRepository
  include Mortymer::DependenciesDsl

  inject Database
  inject MyLogger, as: :logger_service

  def find_user(id)
    @logger_service.log("Finding user #{id}")
    @database.query("SELECT * FROM users WHERE id = #{id}")
  end
end

class EmailService
  include Mortymer::DependenciesDsl

  inject MyLogger

  def send_email(to, message)
    @my_logger.log("Sending email to #{to}: #{message}")
    "Email sent"
  end
end

class UserService
  include Mortymer::DependenciesDsl

  inject UserRepository
  inject EmailService

  def process_user(id)
    user = @user_repository.find_user(id)
    @email_service.send_email("user@example.com", "User processed: #{user}")
  end
end

class CircularA
  include Mortymer::DependenciesDsl
  inject :CircularB
end

class CircularB
  include Mortymer::DependenciesDsl
  inject :CircularA
end

# This is required to use Dry Types
module Types
  include Dry.Types()
end

# A test input class for test endpoints
class TestInput < Dry::Struct
  attribute :name, Types::String
  attribute :age, Types::Integer.optional
end

# A test output class
class TestOutput < Dry::Struct
  attribute :id, Types::Integer
  attribute :name, Types::String
  attribute :created_at, Types::JSON::DateTime
end

# A test input class to different endpoints
class UserProfileInput < Dry::Struct
  attribute :user_id, Types::Integer
  attribute :email, Types::String
end

# A test output class to different endpoints
class UserProfileOutput < Dry::Struct
  attribute :user_id, Types::Integer
  attribute :email, Types::String
  attribute :profile_completed, Types::Bool
end

class QueryParamsInput
  def self.json_schema
    {
      type: :object,
      properties: {
        name: { type: "string" },
        age: { type: "integer" }
      },
      required: [:name]
    }
  end
end

class SimpleQueryParamsInput < Dry::Struct
  attribute :email, Types::String
  attribute :active, Types::Bool
end
