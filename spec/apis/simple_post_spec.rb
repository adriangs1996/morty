# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class WriterService
  extend Morty::Service
  act_as_writer_service!

  sig { returns(InnerResponse) }
  def call
    InnerResponse.new(message: "Hello World")
  end
end

RSpec.describe "Post request without params" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

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
