# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class TestLogger
  def initialize(*); end

  sig { params(message: String).returns(String) }
  def log_message(message)
    message
  end
end

class GetDependencies < Morty::Service
  extend T::Generic
  I = type_member { { fixed: GetDependenciesConcreteInput } }

  const :logger, TestLogger

  sig { override.params(params: GetDependenciesConcreteInput).returns(Response) }
  def call(params)
    Response.new(inner: InnerResponse.new(message: logger.log_message("At age #{params.age} you receive #{params.message}")))
  end
end

RSpec.describe "Read service with dependency injection via constructor" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    get "/get-dependencies?message=Hello World&age=10&salute=true"
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
