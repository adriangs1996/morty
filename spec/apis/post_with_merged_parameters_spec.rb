# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class PostMergedParams
  class Payload < T::Struct
    const :message, String
    const :age, Integer
  end

  extend Morty::Service
  act_as_writer_service!

  sig { params(user_id: Integer, payload: Payload).returns(InnerResponse) }
  def call(user_id, payload)
    InnerResponse.new(message: "User #{user_id} writes #{payload.message} with age #{payload.age}")
  end
end

RSpec.describe "Post request with mixed params" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  before do
    data = {
      payload: {
        message: "Hello World",
        age: 10
      }
    }
    post "/post-merged-params?user_id=1", data.to_json
  end

  it "should return json as default" do
    expect(JSON.parse(last_response.body)).to eq({ "message" => "User 1 writes Hello World with age 10" })
  end
end
