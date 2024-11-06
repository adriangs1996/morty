# frozen_string_literal: true
# typed: true

require "sorbet-runtime"

module Morty
  # A response for a morty service
  class Response < T::Struct
    const :body, T.nilable(T::Struct)
    const :status_code, Integer, default: 204
    const :content_type, String, default: "application/json"
  end

  # A helper classes to return Json results
  class Json
    sig { params(body: Typed::Result[T::Struct, T::Struct]).returns(Typed::Success[Response]) }
    def self.ok(body)
      if body.success?
        Typed::Success.new(
          Response.new(body: body.payload, status_code: 200)
        )
      else
        Typed::Success.new(
          Response.new(body: body.error, status_code: 400)
        )
      end
    end

    sig { returns(Typed::Success[Response]) }
    def self.blank
      Typed::Success.new(Response.new)
    end
  end
end
