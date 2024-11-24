# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class GetWithParamsService
  include Morty::Service
  

  sig { override.params(params: GetDependenciesConcreteInput).returns(Response) }
  def call(params)
    Response.new(inner: InnerResponse.new(message: "At age #{params.age} you receive #{params.message}"))
  end
end

class GetKwargsParams < T::Struct
  const :message, String
  const :age, Integer
  const :salute, T::Boolean, default: false
end

class GetKwargs
  include Morty::Service
  

  sig { override.params(params: GetKwargsParams).returns(Response) }
  def call(params)
    Response.new(
      inner: InnerResponse.new(
        message: "At age #{params.age} you receive #{params.message} and salute: #{params.salute}"
      )
    )
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

  it "should return json as default" do
    expect(last_response.body).to eq(
      JSON.dump({ inner: { message: "At age 10 you receive Hello World and salute: true" } })
    )
  end
end
