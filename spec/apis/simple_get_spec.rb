# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class GreeterService < Morty::Service
  I = type_member { { fixed: Morty::Empty } }
  R = type_member { { fixed: Response } }

  sig { override.params(_params: Morty::Empty).returns(Response) }
  def call(_params)
    Response.new(inner: InnerResponse.new(message: "Hello World"))
  end
end

RSpec.describe "Read service without parameters" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  it "should return status 200" do
    get "/greeter"
    expect(last_response.status).to eq(200)
  end

  it "should respond to ending / as well" do
    get "/greeter/"
    expect(last_response.status).to eq(200)
  end

  it "should return 404 if not existing path" do
    get "/asdasdasd"
    expect(last_response.status).to eq(404)
  end

  it "should return json as default" do
    get "/greeter"
    expect(last_response.body).to eq(JSON.dump({ inner: { message: "Hello World" } }))
  end

  it "should not receive post requests" do
    post "/greeter"
    expect(last_response.status).to eq(405)
  end
end
