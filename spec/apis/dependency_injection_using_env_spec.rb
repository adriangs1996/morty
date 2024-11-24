# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

module Users
  class User < T::Struct
    const :username, String
    const :password, String
  end

  class UserError < T::Struct
    const :message, String
  end

  module IAuthService
    interface!

    sig { abstract.returns(Typed::Result[User, UserError]) }
    def authenticated_user; end
  end

  class PersonalInformation < T::Struct
    include Morty::Service
    include Morty::Json

    

    const :auth_service, IAuthService

    sig { override.params(_params: Morty::Empty).returns(T.any(User, UserError)) }
    def call(_params)
      if auth_service.authenticated_user.success?
        json_ok auth_service.authenticated_user.payload
      else
        json_bad auth_service.authenticated_user.error
      end
    end
  end
end

class AuthenticationService
  include Users::IAuthService
  include Morty::AppDependency

  sig { override.params(request: T.nilable(Rack::Request)).void }
  def build(request = nil)
    request = T.cast(request, Rack::Request)
    @header = request.get_header("Authentication") || "Bearer WRONG"
    @header.split(" ").last.tap do |token|
      @authenticated_user = if token == "SECRET"
                              Typed::Success.new(Users::User.new(username: "user", password: "secret"))
                            else
                              Typed::Failure.new(Users::UserError.new(message: "User not authenticated"))
                            end
    end
  end

  sig { override.returns(Typed::Result[Users::User, Users::UserError]) }
  attr_reader :authenticated_user
end

Morty::Dependency.register(Users::IAuthService, AuthenticationService)

RSpec.describe "Dependency injection built from request" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  it "should return status 400 when user not authenticated" do
    get "/users/personal-information"
    expect(last_response.status).to eq(400)
    response = JSON.parse(last_response.body)
    expect(response["message"]).to eq("User not authenticated")
  end

  it "should return an user when authenticated" do
    get "/users/personal-information", {}, { "Authentication" => "Bearer SECRET" }
    expect(last_response.status).to eq(200)
    response = JSON.parse(last_response.body)
    expect(response["username"]).to eq("user")
  end
end
