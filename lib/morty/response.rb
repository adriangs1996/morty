# frozen_string_literal: true
# typed: true

require "sorbet-runtime"

module Morty
  class Empty < T::Struct
  end

  class ErrorLocation < T::Enum
    enums do
      Path = new
      Query = new
      Params = new
      Body = new
      Headers = new
      Unknow = new
    end
  end

  class ServiceError < T::Struct
    const :error_message, String
    const :field, T.nilable(String)
    const :location, ErrorLocation, default: ErrorLocation::Unknow
  end

  class ErrorResponse < T::InexactStruct
    const :errors, T::Array[ServiceError], default: []
    const :context, T::Hash[String, T.anything], default: {}
  end

  ModelType = T.type_alias { T.any(T::Struct, T::InexactStruct) }

  class Response
    extend T::Generic
    R = type_member

    attr_reader :response, :status_code, :content_type

    sig do
      params(response: R, status_code: Integer, content_type: String).void
    end
    def initialize(response:, status_code: 200, content_type: "application/json")
      @response = response
      @status_code = status_code
      @cotent_type = content_type
    end
  end

  CONTENT_TYPES = {
    json: "application/json",
    js: "application/javascript",
    html: "text/html",
    xml: "application/xml",
    css: "text/css",
    stream: "application/octet-stream"
  }

  module HttpMetadata
    def __status_code
      @__status_code ||= 200
    end

    def __serializer
      @__serializer ||= :json
    end

    def __set_serializer(serializer)
      @__serializer = serializer
    end

    def __content_type
      @__content_type ||= "application/json"
    end

    def __set_content_type(content_type)
      @__content_type = content_type
    end

    def __set_status_code(status_code)
      @__status_code = status_code
    end

    sig do
      type_parameters(:O).params(content: Symbol,
                                 status: Integer,
                                 body: T.type_parameter(:O)).returns(T.type_parameter(:O))
    end
    def render(content, status, body)
      __set_content_type(CONTENT_TYPES[content])
      __set_status_code(status)
      __set_serializer(content)
      body
    end
  end

  # A helper classes to return Json results
  module Json
    include HttpMetadata

    sig do
      type_parameters(:O).params(body: T.type_parameter(:O)).returns(T.type_parameter(:O))
    end
    def json_ok(body)
      render(:json, 200, body)
    end

    sig do
      type_parameters(:O).params(body: T.type_parameter(:O)).returns(T.type_parameter(:O))
    end
    def json_bad(body)
      render(:json, 400, body)
    end

    sig do
      type_parameters(:O).params(body: T.type_parameter(:O)).returns(T.type_parameter(:O))
    end
    def json_unprocessable(body)
      render(:json, 422, body)
    end
  end
end
