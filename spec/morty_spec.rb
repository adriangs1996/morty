# frozen_string_literal: true

require "rack"
require "rack/test"

class GreeterService
  include Morty::Service

  class InnerResponse < T::Struct
    const :message, String
  end

  class Response < T::Struct
    const :inner, InnerResponse
  end

  sig { override(allow_incompatible: true).returns(Response) }
  def call
    Response.new(inner: InnerResponse.new(message: "Hello World"))
  end
end

RSpec.describe Morty::App do
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  context "requests to greeter service" do
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
  end
end
