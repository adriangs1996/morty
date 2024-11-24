# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class AgeAndMessageStruct < T::Struct
  const :age, Integer
  const :message, String
end

class PostMergedParams
  include Morty::Service
  act_as_writer_service!

  class Payload < T::Struct
    const :payload, AgeAndMessageStruct
    const :user_id, Integer
  end

  

  sig { override.params(params: Payload).returns(InnerResponse) }
  def call(params)
    InnerResponse.new(message: "User #{params.user_id} writes #{params.payload.message} with age #{params.payload.age}")
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
