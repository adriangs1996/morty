# frozen_string_literal: true

require "dry-types"

module Mortymer
  module Types
    include Dry.Types()

    class RackFile
      attr_reader :tempfile, :original_filename, :content_type

      def initialize(tempfile:, original_filename:, content_type:)
        @tempfile = tempfile
        @original_filename = original_filename
        @content_type = content_type
      end

      def self.new_from_rack_file(file)
        return nil if file.nil?

        new(
          tempfile: file.respond_to?(:tempfile) ? file.tempfile : file[:tempfile],
          original_filename: file.respond_to?(:original_filename) ? file.original_filename : file[:original_filename],
          content_type: file.respond_to?(:content_type) ? file.content_type : file[:content_type]
        )
      end
    end

    # Define a custom type for handling file uploads
    UploadedFile = Types.Constructor(RackFile) do |value|
      case value
      when RackFile
        value
      when Hash
        RackFile.new_from_rack_file(value)
      when ActionDispatch::Http::UploadedFile
        RackFile.new_from_rack_file(value)
      when NilClass
        nil
      else
        raise Dry::Types::CoercionError, "#{value.inspect} cannot be coerced to UploadedFile"
      end
    end.meta(
      swagger: {
        type: "file"
      }
    )

    # Array of files
    UploadedFiles = Types::Array.of(File)
  end
end
