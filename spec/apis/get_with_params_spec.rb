# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class GetWithParamsService
  extend Morty::Service

  sig { params(message: String, age: Integer).returns(Response) }
  def call(message, age)
    Response.new(inner: InnerResponse.new(message: "At age #{age} you receive #{message}"))
  end
end

class GetKwargs
  extend Morty::Service

  sig { params(message: String, age: Integer, salute: T::Boolean).returns(Response) }
  def call(message, age:, salute: false)
    Response.new(inner: InnerResponse.new(message: "At age #{age} you receive #{message} and salute: #{salute}"))
  end
end

RSpec.describe "Read service with positional parameters" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    get "/get-with-params?message=Hello World&age=10&salute=true"
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

RSpec.describe "Read service with parameters merged with kwargs" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    get "/get-kwargs?message=Hello World&age=10&salute=true"
  end

  it "should return status 200" do
    expect(last_response.status).to eq(200)
  end

  it "should respond to ending / as well" do
    expect(last_response.status).to eq(200)
  end

  it "should return json as default" do
    expect(last_response.body).to eq(
      JSON.dump({ inner: { message: "At age 10 you receive Hello World and salute: true" } })
    )
  end
end
