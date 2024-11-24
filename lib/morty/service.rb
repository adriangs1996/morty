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
    include HttpMetadata
    extend T::Generic
    abstract!

    def self.included(service)
      super
      SERVICE_TRACKER << service unless SERVICE_TRACKER.include?(service)
    end

    # Utility functions added to each service
    module ClassMethods
      sig { returns(T::Boolean) }
      def writer_service?
        !@act_as_writer_service.nil? && @act_as_writer_service
      end

      sig { void }
      def act_as_writer_service!
        @act_as_writer_service = true
      end
    end

    mixes_in_class_methods(ClassMethods)
    mixes_in_class_methods(PathDslMixin)

    sig { abstract.params(params: T.untyped).returns(ModelType) }
    def call(params); end
  end
end
