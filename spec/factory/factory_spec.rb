# frozen_string_literal: true
# typed: true

require_relative "../../lib/morty/factory"

class SimpleObject
  sig { returns(String) }
  attr_reader :message

  def build(env)
    @message = env[:message]
  end

  def call
    message
  end
end

RSpec.describe "A simple object created with the factory" do
  T.bind(self, T.untyped)

  before do
    @factory = Morty::Factory.new({ message: "Hello World" }, {})
    @object = @factory.create_instance_of_type(SimpleObject)
  end

  it "should build an instance of Simple Object" do
    expect(@object.class).to be(SimpleObject)
  end

  it "should call the build method to instantiate that object" do
    expect(@object.call).to eq("Hello World")
  end
end
