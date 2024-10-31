# frozen_string_literal: true
# typed: true

require_relative "../../../lib/morty"

class InnerResponse < T::Struct
  const :message, String
end

# An example greeter response
class GreeterResponse < T::Struct
  const :salute, String
  const :inner, InnerResponse
end

module GreeterApi
  # An example greeter service
  class SayHi
    include Morty::Service

    def initialize; end

    sig { override(allow_incompatible: true).returns(GreeterResponse) }
    def call
      GreeterResponse.new(salute: "Hello World", inner: InnerResponse.new(message: "Hello from inside rerun"))
    end
  end
end
