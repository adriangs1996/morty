# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mortymer::ApiMetadata do # rubocop:disable Metrics/BlockLength
  let(:input_class) { TestInput }
  let(:output_class) { TestOutput }

  describe "DSL methods" do # rubocop:disable Metrics/BlockLength
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    describe ".get" do
      it "configures a GET endpoint" do
        # Call the class registration
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          get input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:get)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          get input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".post" do
      it "configures a POST endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          post input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:post)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          post input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".put" do
      it "configures a PUT endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          put input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:put)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          put input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end

    describe ".delete" do
      it "configures a DELETE endpoint" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          delete input: TestInput, output: TestOutput
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.http_method).to eq(:delete)
        expect(endpoint.input_class).to eq(TestInput)
        expect(endpoint.output_class).to eq(TestOutput)
        expect(endpoint.path).to eq("/test")
      end

      it "allows custom path" do
        class TestEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
          include Mortymer::ApiMetadata

          delete input: TestInput, output: TestOutput, path: "/custom/path"
          def call(input); end
        end
        expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
        endpoint = Mortymer::EndpointRegistry.registry.first
        expect(endpoint.path).to eq("/custom/path")
      end
    end
  end

  describe "path inference" do # rubocop:disable Metrics/BlockLength
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    it "infers path from namespaced class name" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          module Users
            class ProfileEndpoint
              include Mortymer::ApiMetadata
              get input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end
      end
      expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
      endpoint = Mortymer::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/api/v1/users/profile")
    end

    it "removes _endpoint suffix" do
      class UsersEndpoint # rubocop:disable Lint/ConstantDefinitionInBlock
        include Mortymer::ApiMetadata
        get input: TestInput, output: TestOutput
        def call(params); end
      end
      expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
      endpoint = Mortymer::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/users")
    end

    it "removes _controller suffix" do
      class UsersController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Mortymer::ApiMetadata
        get input: TestInput, output: TestOutput
        def call(params); end
      end
      expect(Mortymer::EndpointRegistry.registry.count).to eq(1)
      endpoint = Mortymer::EndpointRegistry.registry.first
      expect(endpoint.infer_path_from_class).to eq("/users")
    end
  end

  describe ".routeable?" do
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    it "returns true when all required attributes are set" do
      class TestController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Mortymer::ApiMetadata
        get input: TestInput, output: TestOutput
        def call; end
      end

      endpoint = Mortymer::EndpointRegistry.registry.last
      expect(endpoint.routeable?).to be true
    end

    it "returns false when attributes are missing" do
      class TestController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Mortymer::ApiMetadata
      end

      expect(Mortymer::EndpointRegistry.registry).to be_empty
    end
  end

  describe ".api_name" do
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    it "returns formatted api name" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          module Users
            class ProfileEndpoint
              include Mortymer::ApiMetadata
              get input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end
      end

      endpoint = Mortymer::EndpointRegistry.registry.last
      expect(endpoint.api_name).to eq("api/v1/users/profile")
    end
  end

  describe ".generate_openapi_schema" do # rubocop:disable Metrics/BlockLength
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    context "with GET endpoint" do
      it "generates OpenAPI schema with parameters" do
        module API # rubocop:disable Lint/ConstantDefinitionInBlock
          module V1
            class TestController
              include Mortymer::ApiMetadata
              get input: UserProfileInput, output: UserProfileOutput
              def call(params); end
            end
          end
        end

        endpoint = Mortymer::EndpointRegistry.registry.last
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
              include Mortymer::ApiMetadata
              post input: TestInput, output: TestOutput
              def call(params); end
            end
          end
        end

        endpoint = Mortymer::EndpointRegistry.registry.last
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

  describe "integration with Sigil" do # rubocop:disable Metrics/BlockLength
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    it "works with both Sigil and ApiMetadata" do
      class IntegratedController # rubocop:disable Lint/ConstantDefinitionInBlock
        include Mortymer::ApiMetadata

        get input: TestInput, output: TestOutput
        def call(params)
          puts params.class
        end
      end

      endpoint = Mortymer::EndpointRegistry.registry.last
      expect(endpoint.routeable?).to be true
      expect(endpoint.http_method).to eq(:get)
    end

    it "maintains proper method hook chain order" do
      HOOKS_CALLS = [] # rubocop:disable Lint/ConstantDefinitionInBlock

      module TestHookTracker # rubocop:disable Lint/ConstantDefinitionInBlock
        def method_added(name)
          super
          HOOKS_CALLS << "#{self.name}##{name}"
        end
      end

      class TrackedController # rubocop:disable Lint/ConstantDefinitionInBlock
        extend TestHookTracker
        include Mortymer::ApiMetadata

        get input: TestInput, output: TestOutput
        def call(params)
          TestOutput.new(
            id: 1, name: params.name, created_at: DateTime.now
          )
        end
      end

      # Verify both modules processed the method
      expect(HOOKS_CALLS).to include("TrackedController#call")
      expect(Mortymer::EndpointRegistry.registry.last.routeable?).to be true
      controller = TrackedController.new
      expect(controller.call({ name: "Kmi", age: 28 })).to be_a(TestOutput)
    end
  end

  describe "operation ID generation" do # rubocop:disable Metrics/BlockLength
    before do
      Mortymer::EndpointRegistry.registry.clear
    end

    it "generates correct operation ID for GET" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          class UsersController
            include Mortymer::ApiMetadata
            get input: TestInput, output: TestOutput
            def call(params); end
          end
        end
      end

      endpoint = Mortymer::EndpointRegistry.registry.last
      schema = endpoint.generate_openapi_schema
      expect(schema["/api/v1/users"]["get"][:operation_id]).to eq("get_users")
    end

    it "generates correct operation ID for POST" do
      module API # rubocop:disable Lint/ConstantDefinitionInBlock
        module V1
          class UsersController
            include Mortymer::ApiMetadata
            post input: TestInput, output: TestOutput
            def call(params); end
          end
        end
      end

      endpoint = Mortymer::EndpointRegistry.registry.last
      schema = endpoint.generate_openapi_schema
      expect(schema["/api/v1/users"]["post"][:operation_id]).to eq("create_users")
    end
  end
end
