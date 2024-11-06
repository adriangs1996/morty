# frozen_string_literal: true
# typed: true

require_relative "response"

module Morty
  SERVICE_TRACKER = []

  # A generic service error
  class Error < StandardError
    attr_accessor :code, :message

    def initialize(code:, message:)
      super
      @code = code
      @message = message
    end
  end

  class Empty < T::Struct
  end

  # Services are the abstractions over endpoints.
  # each service has a common interface, that is,
  # they are methods or procs that responds to call
  # with optionally requiring a typed params and a typed
  # data (for path and query string params or body params respectively)
  class Service < T::InexactStruct
    extend T::Generic
    abstract!

    I = type_member { { upper: T::Struct } }
    R = type_member { { upper: T::Struct } }

    def self.inherited(service)
      super
      SERVICE_TRACKER << service unless SERVICE_TRACKER.include?(service)
      service.extend(ClassMethods)
    end

    sig { returns(T::Boolean) }
    def self.writer_service?
      !@act_as_writer_service.nil? && @act_as_writer_service
    end

    sig { void }
    def self.act_as_writer_service!
      @act_as_writer_service = true
    end

    sig { abstract.params(params: I).returns(R) }
    def call(params); end
  end
end
