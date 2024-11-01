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

  # Services are the abstractions over endpoints.
  # each service has a common interface, that is,
  # they are methods or procs that responds to call
  # with optionally requiring a typed params and a typed
  # data (for path and query string params or body params respectively)
  module Service
    def self.extended(service)
      SERVICE_TRACKER << service unless SERVICE_TRACKER.include?(service)
    end

    sig { void }
    def act_as_writer_service!
      @act_as_writer_service = true
    end

    sig { returns(T::Boolean) }
    def writer_service?
      !@act_as_writer_service.nil? && @act_as_writer_service
    end
  end
end
