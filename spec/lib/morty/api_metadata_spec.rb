# frozen_string_literal: true

require "spec_helper"

RSpec.describe Morty::ApiMetadata do # rubocop:disable Metrics/BlockLength
  # Using real Dry::Struct classes defined in support/test_classes.rb
  let(:input_class) { TestInput }
  let(:output_class) { TestOutput }

  describe "DSL methods" do # rubocop:disable Metrics/BlockLength
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    before do
      stub_const("API::V1::TestEndpoint", endpoint_class)
    end

    describe ".get" do
      it "configures a GET endpoint" do
        endpoint_class.get(input: TestInput, output: TestOutput)

        expect(endpoint_class.http_method).to eq(:get)
        expect(endpoint_class.input_class).to eq(TestInput)
        expect(endpoint_class.output_class).to eq(TestOutput)
        expect(endpoint_class.path).to eq("/api/v1/test")
      end

      it "allows custom path" do
        endpoint_class.get(input: TestInput, output: TestOutput, path: "/custom/path")
        expect(endpoint_class.path).to eq("/custom/path")
      end
    end

    describe ".post" do
      it "configures a POST endpoint" do
        endpoint_class.post(input: TestInput, output: TestOutput)

        expect(endpoint_class.http_method).to eq(:post)
        expect(endpoint_class.input_class).to eq(TestInput)
        expect(endpoint_class.output_class).to eq(TestOutput)
        expect(endpoint_class.path).to eq("/api/v1/test")
      end
    end

    describe ".put" do
      it "configures a PUT endpoint" do
        endpoint_class.put(input: TestInput, output: TestOutput)

        expect(endpoint_class.http_method).to eq(:put)
        expect(endpoint_class.input_class).to eq(TestInput)
        expect(endpoint_class.output_class).to eq(TestOutput)
        expect(endpoint_class.path).to eq("/api/v1/test")
      end
    end

    describe ".delete" do
      it "configures a DELETE endpoint" do
        endpoint_class.delete(input: TestInput, output: TestOutput)

        expect(endpoint_class.http_method).to eq(:delete)
        expect(endpoint_class.input_class).to eq(TestInput)
        expect(endpoint_class.output_class).to eq(TestOutput)
        expect(endpoint_class.path).to eq("/api/v1/test")
      end
    end
  end

  describe "path inference" do
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    it "infers path from namespaced class name" do
      stub_const("API::V1::Users::ProfileEndpoint", endpoint_class)
      expect(endpoint_class.infer_path_from_class).to eq("/api/v1/users/profile")
    end

    it "removes _endpoint suffix" do
      stub_const("UsersEndpoint", endpoint_class)
      expect(endpoint_class.infer_path_from_class).to eq("/users")
    end

    it "removes _controller suffix" do
      stub_const("UsersController", endpoint_class)
      expect(endpoint_class.infer_path_from_class).to eq("/users")
    end
  end

  describe ".routeable?" do
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    before do
      stub_const("TestEndpoint", endpoint_class)
    end

    it "returns true when all required attributes are set" do
      endpoint_class.get(input: TestInput, output: TestOutput)
      expect(endpoint_class.routeable?).to be true
    end

    it "returns false when attributes are missing" do
      expect(endpoint_class.routeable?).to be false
    end
  end

  describe ".api_name" do
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    it "returns formatted api name" do
      stub_const("API::V1::Users::ProfileEndpoint", endpoint_class)
      expect(endpoint_class.api_name).to eq("api/v1/users/profile")
    end
  end

  describe ".generate_openapi_schema" do # rubocop:disable Metrics/BlockLength
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    before do
      stub_const("API::V1::TestEndpoint", endpoint_class)
    end

    context "with GET endpoint" do
      before do
        endpoint_class.get(input: UserProfileInput, output: UserProfileOutput)
      end

      it "generates OpenAPI schema with parameters" do
        schema = endpoint_class.generate_openapi_schema

        expect(schema["/api/v1/test"]).to be_present
        expect(schema["/api/v1/test"]["get"]).to be_present

        parameters = schema["/api/v1/test"]["get"][:parameters]
        expect(parameters).to be_present
        expect(parameters.find { |p| p[:name] == :user_id }).to be_present
        expect(parameters.find { |p| p[:name] == :email }).to be_present

        success_response = schema["/api/v1/test"]["get"][:responses]["200"]
        expect(success_response).to be_present
        expect(success_response[:content]["application/json"][:schema]).to eq("$ref": "#/components/schemas/UserProfileOutput")

        expect(schema["/api/v1/test"]["get"][:responses]["422"]).to be_present
      end
    end

    context "with POST endpoint" do
      before do
        endpoint_class.post(input: TestInput, output: TestOutput)
      end

      it "generates OpenAPI schema with request body" do
        schema = endpoint_class.generate_openapi_schema

        request_body = schema["/api/v1/test"]["post"][:requestBody]
        expect(request_body).to be_present
        expect(request_body[:content]["application/json"][:schema]).to eq("$ref": "#/components/schemas/TestInput")

        success_response = schema["/api/v1/test"]["post"][:responses]["200"]
        expect(success_response).to be_present
        expect(success_response[:content]["application/json"][:schema]).to eq("$ref": "#/components/schemas/TestOutput")
      end
    end
  end

  describe "operation ID generation" do
    let(:endpoint_class) do
      Class.new do
        include Morty::ApiMetadata
      end
    end

    before do
      stub_const("API::V1::UsersEndpoint", endpoint_class)
    end

    it "generates correct operation ID for GET" do
      endpoint_class.get(input: TestInput, output: TestOutput)
      schema = endpoint_class.generate_openapi_schema
      expect(schema["/api/v1/users"]["get"][:operation_id]).to eq("get_users")
    end

    it "generates correct operation ID for POST" do
      endpoint_class.post(input: TestInput, output: TestOutput)
      schema = endpoint_class.generate_openapi_schema
      expect(schema["/api/v1/users"]["post"][:operation_id]).to eq("create_users")
    end
  end
end
