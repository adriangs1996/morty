# frozen_string_literal: true

require "spec_helper"

RSpec.describe Morty::OpenapiGenerator do # rubocop:disable Metrics/BlockLength
  include Morty::Utils::StringTransformations

  let(:test_input) do
    Class.new(Dry::Struct) do
      def self.name
        "TestInput"
      end
      attribute :name, Types::String
    end
  end

  let(:test_output) do
    Class.new(Dry::Struct) do
      def self.name
        "TestOutput"
      end
      attribute :id, Types::Integer
    end
  end

  let(:endpoint) do
    Morty::Endpoint.new(
      http_method: :post,
      input_class: test_input,
      output_class: test_output,
      path: "/test",
      name: "API::V1::TestController"
    )
  end

  let(:registry) { [endpoint] }

  let(:generator) do
    described_class.new(
      prefix: "/api",
      title: "Test API",
      version: "v1",
      description: "Test Description",
      registry: registry
    )
  end

  describe "#generate" do # rubocop:disable Metrics/BlockLength
    subject(:generated_doc) { generator.generate }

    it "generates basic OpenAPI structure" do
      expect(generated_doc[:openapi]).to eq("3.0.1")
      expect(generated_doc[:info]).to include(
        title: "Test API",
        version: "v1",
        description: "Test Description"
      )
      expect(generated_doc[:paths]).to be_a(Hash)
      expect(generated_doc[:components][:schemas]).to be_a(Hash)
    end

    it "includes Error422 schema" do
      error_schema = generated_doc[:components][:schemas]["Error422"]
      expect(error_schema).to include(
        type: "object",
        required: %w[error details],
        properties: {
          error: {
            type: "string",
            description: "Error type identifier",
            example: "Validation Failed"
          },
          details: {
            type: "string",
            description: "Detailed error message",
            example: 'type_error: ["foo"] is not a valid Integer'
          }
        }
      )
    end

    context "with registered endpoints" do
      it "generates paths with prefix" do
        expect(generated_doc[:paths].keys.first).to start_with("/api")
      end

      it "includes input and output schemas" do
        schemas = generated_doc[:components][:schemas]
        expect(schemas.keys).to include(demodulize(test_input.name))
        expect(schemas.keys).to include(demodulize(test_output.name))
      end
    end

    context "with non-routeable endpoints" do
      let(:non_routeable_endpoint) do
        instance_double(Morty::Endpoint, routeable?: false)
      end
      let(:registry) { [non_routeable_endpoint] }

      it "excludes non-routeable endpoints" do
        expect(generated_doc[:paths]).to be_empty
      end
    end
  end
end
