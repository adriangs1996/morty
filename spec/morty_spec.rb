# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"

class InnerResponse < T::Struct
  const :message, String
end

class GreeterService
  extend Morty::Service

  class Response < T::Struct
    const :inner, InnerResponse
  end

  sig { returns(Response) }
  def call
    Response.new(inner: InnerResponse.new(message: "Hello World"))
  end
end

class WriterService
  extend Morty::Service
  act_as_writer_service!

  sig { returns(InnerResponse) }
  def call
    InnerResponse.new(message: "Hello World")
  end
end

RSpec.describe Morty::App do
  T.bind(self, T.untyped)
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

    it "should not receive post requests" do
      post "/greeter"
      expect(last_response.status).to eq(405)
    end
  end

  context "writer service" do
    it "should accept a post request" do
      post "/writer"
      expect(last_response.status).to eq(200)
    end

    it "should return json as default" do
      post "/writer"
      expect(JSON.parse(last_response.body)).to eq({ "message" => "Hello World" })
    end

    it "should not accept a get request" do
      get "/writer"
      expect(last_response.status).to eq(405)
    end

    it "should accept a put request" do
      put "/writer"
      expect(last_response.status).to eq(200)
    end
  end
end
