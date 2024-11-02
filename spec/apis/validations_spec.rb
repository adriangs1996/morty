# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class PostValidationService
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
      payload: {}
    }
    post "/post-validation?user_id=1", data.to_json
  end

  it "should return status 422" do
    expect(last_response.status).to eq(422)
  end

  it "should return json as default with an error" do
    expect(JSON.parse(last_response.body))
      .to eq({ "error" => "Multiple validation errors found: message is required. | age is required." })
  end
end
