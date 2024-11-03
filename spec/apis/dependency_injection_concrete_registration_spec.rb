# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

module ILogger
  interface!

  sig { abstract.params(message: String).returns(String) }
  def log_message(message); end
end

class TestLoggerConcrete < Morty::AppDependency
  include ILogger
  implements(interface: ILogger)

  sig { override.params(message: String).returns(String) }
  def log_message(message)
    message
  end
end

class GetDependenciesConcrete < T::Struct
  extend Morty::Service

  const :logger, ILogger

  sig { params(message: String, age: Integer).returns(Response) }
  def call(message, age)
    Response.new(inner: InnerResponse.new(message: logger.log_message("At age #{age} you receive #{message}")))
  end
end

RSpec.describe "Read service with dependency injection with concrete implementation" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    get "/get-dependencies-concrete?message=Hello World&age=10&salute=true"
  end

  it "should return status 200" do
    expect(last_response.status).to eq(200)
  end

  it "should respond to ending / as well" do
    expect(last_response.status).to eq(200)
  end

  it "should return json as default" do
    expect(last_response.body).to eq(JSON.dump({ inner: { message: "At age 10 you receive Hello World" } }))
  end
end
