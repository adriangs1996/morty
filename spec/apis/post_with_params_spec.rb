# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class Payload < T::Struct
  const :message, String
  const :age, Integer
end

class WriterWithParamsService < Morty::Service
  act_as_writer_service!

  R = type_member { { fixed: InnerResponse } }
  I = type_member { { fixed: Payload } }

  sig { override.params(params: Payload).returns(InnerResponse) }
  def call(params)
    InnerResponse.new(message: params.message)
  end
end

RSpec.describe "Post request with params from querystring" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    post "/writer-with-params?message=Hello World&age=10"
  end

  it "should return json as default" do
    expect(JSON.parse(last_response.body)).to eq({ "message" => "Hello World" })
  end
end

RSpec.describe "Post request with params" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    data = {
      message: "Hello World",
      age: 10
    }
    post "/writer-with-params", data.to_json
  end

  it "should accept a post request" do
    expect(last_response.status).to eq(200)
  end

  it "should return json as default" do
    expect(JSON.parse(last_response.body)).to eq({ "message" => "Hello World" })
  end

  it "should not accept a get request" do
    get "/writer-with-params"
    expect(last_response.status).to eq(405)
  end

  it "should accept a put request" do
    expect(last_response.status).to eq(200)
  end
end
