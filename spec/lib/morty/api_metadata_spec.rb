# frozen_string_literal: true

require "spec_helper"

RSpec.describe Morty::ApiMetadata do # rubocop:disable Metrics/BlockLength
  let(:input_class) { TestInput }
  let(:output_class) { TestOutput }

  describe "DSL methods" do # rubocop:disable Metrics/BlockLength
    before do
      Morty::EndpointRegistry.registry.clear
    end

    describe ".get" do
      it "configures a GET endpoint" do
        # Call the class registration
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          get input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:get)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          get input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".post" do
      it "configures a POST endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          post input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:post)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          post input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".put" do
      it "configures a PUT endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          put input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:put)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          put input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".delete" do
      it "configures a DELETE endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          delete input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:delete)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Morty::ApiMetadata

          delete input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Morty::EndpointRegistry.registry.count).to eq(1)
        endpoint = Morty::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end
  end

  describe "path inference" do # rubocop:disable Metrics/BlockLength
    before do
      Morty::EndpointRegistry.registry.clear
    end

    it "infers path from namespaced class name" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          module Users
            class ProfileEndpoint
              include Morty::ApiMetadata
              get input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end
      end
      expect(Morty::EndpointRegistry.registry.count).to eq(1)
      endpoint = Morty::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/api/v1/users/profile")
    end

    it "removes _endpoint suffix" do
      class UsersEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
        include Morty::ApiMetadata
        get input: TestInput, output: TestOutput
        def call(params); end
      end
      expect(Morty::EndpointRegistry.registry.count).to eq(1)
      endpoint = Morty::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/users")
    end

    it "removes _controller suffix" do
      class UsersController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Morty::ApiMetadata
        get input: TestInput, output: TestOutput
        def call(params); end
      end
      expect(Morty::EndpointRegistry.registry.count).to eq(1)
      endpoint = Morty::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/users")
    end
  end

  describe ".routeable?" do
    before do
      Morty::EndpointRegistry.registry.clear
    end

    it "returns true when all required attributes are set" do
      class TestController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Morty::ApiMetadata
        get input: TestInput, output: TestOutput
        def call; end
      end

      endpoint = Morty::EndpointRegistry.registry.last
      expect(endpoint.routeable?).to be true
    end

    it "returns false when attributes are missing" do
      class TestController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Morty::ApiMetadata
      end

      expect(Morty::EndpointRegistry.registry).to be_empty
    end
  end

  describe ".api_name" do
    before do
      Morty::EndpointRegistry.registry.clear
    end

    it "returns formatted api name" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          module Users
            class ProfileEndpoint
              include Morty::ApiMetadata
              get input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end
      end

      endpoint = Morty::EndpointRegistry.registry.last
      expect(endpoint.api_name).to eq("api/v1/users/profile")
    end
  end

  describe ".generate_openapi_schema" do # rubocop:disable Metrics/BlockLength
    before do
      Morty::EndpointRegistry.registry.clear
    end

    context "with GET endpoint" do
      it "generates OpenAPI schema with parameters" do
        module API # rubocop:disable Lint/ConstantDefinitionInBlock
          module V1
            class TestController
              include Morty::ApiMetadata
              get input: UserProfileInput, output: UserProfileOutput
              def call(params); end
            end
          end
        end

        endpoint = Morty::EndpointRegistry.registry.last
        schema = endpoint.generate_openapi_schema

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
      it "generates OpenAPI schema with request body" do
        module API # rubocop:disable Lint/ConstantDefinitionInBlock
          module V1
            class TestController
              include Morty::ApiMetadata
              post input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end

        endpoint = Morty::EndpointRegistry.registry.last
        schema = endpoint.generate_openapi_schema

        request_body = schema["/api/v1/test"]["post"][:requestBody]
        expect(request_body).to be_present
        expect(request_body[:content]["application/json"][:schema]).to eq("$ref": "#/components/schemas/TestInput")

        success_response = schema["/api/v1/test"]["post"][:responses]["200"]
        expect(success_response).to be_present
        expect(success_response[:content]["application/json"][:schema]).to eq("$ref": "#/components/schemas/TestOutput")
      end
    end
  end

  describe "operation ID generation" do # rubocop:disable Metrics/BlockLength
    before do
      Morty::EndpointRegistry.registry.clear
    end

    it "generates correct operation ID for GET" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          class UsersController
            include Morty::ApiMetadata
            get input: TestInput, output: TestOutput
            def call(params); end
          end
        end
      end

      endpoint = Morty::EndpointRegistry.registry.last
      schema = endpoint.generate_openapi_schema
      expect(schema["/api/v1/users"]["get"][:operation_id]).to eq("get_users")
    end

    it "generates correct operation ID for POST" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          class UsersController
            include Morty::ApiMetadata
            post input: TestInput, output: TestOutput
            def call(params); end
          end
        end
      end

      endpoint = Morty::EndpointRegistry.registry.last
      schema = endpoint.generate_openapi_schema
      expect(schema["/api/v1/users"]["post"][:operation_id]).to eq("create_users")
    end
  end
end
