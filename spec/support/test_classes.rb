# frozen_string_literal: true

require "dry/struct"

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
