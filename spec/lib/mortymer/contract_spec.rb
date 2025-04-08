# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Mortymer::Contract do
  # Basic schema with primitive types
  class BasicContract < Mortymer::Contract
    params do
      required(:name).filled(:string)
      required(:age).filled(:integer)
      required(:active).filled(:bool)
    end
    compile!
  end

  # Schema with nested object
  class NestedContract < Mortymer::Contract
    params do
      required(:user).hash do
        required(:name).filled(:string)
        required(:address).hash do
          required(:street).filled(:string)
          required(:city).filled(:string)
          optional(:country).filled(:string)
        end
      end
    end
    compile!
  end

  # Schema with arrays
  class ArrayContract < Mortymer::Contract
    params do
      required(:tags).array(:string)
      required(:scores).array(:integer)
      required(:items).array do
        hash do
          required(:id).filled(:integer)
          required(:name).filled(:string)
        end
      end
    end
    compile!
  end

  # Schema with optional fields and defaults
  class OptionalContract < Mortymer::Contract
    params do
      required(:title).filled(:string)
      optional(:description).maybe(:string)
      optional(:status).filled(String.default("pending"))
      optional(:metadata).hash do
        optional(:created_at).filled(:string)
        optional(:updated_at).filled(:string)
      end
    end
    compile!
  end

  # Schema with enums and custom types
  class EnumContract < Mortymer::Contract
    params do
      required(:role).filled(:string).value(included_in?: %w[admin user guest])
      required(:priority).filled(:integer).value(included_in?: [1, 2, 3])
    end
    compile!
  end

  describe ".structify" do
    context "with basic contract" do
      it "creates a struct with primitive types" do
        params = {
          name: "John Doe",
          age: 30,
          active: true
        }

        result = BasicContract.structify(params)

        expect(result.name).to eq("John Doe")
        expect(result.age).to eq(30)
        expect(result.active).to eq(true)
      end

      it "raises ContractError when validation fails" do
        params = {
          name: "John Doe",
          age: "invalid",
          active: true
        }

        expect do
          BasicContract.structify(params)
        end.to raise_error(Mortymer::Contract::ContractError)
      end
    end

    context "with nested contract" do
      it "creates a struct with nested objects" do
        params = {
          user: {
            name: "John Doe",
            address: {
              street: "123 Main St",
              city: "Boston",
              country: "USA"
            }
          }
        }

        result = NestedContract.structify(params)

        expect(result.user.name).to eq("John Doe")
        expect(result.user.address.street).to eq("123 Main St")
        expect(result.user.address.city).to eq("Boston")
        expect(result.user.address.country).to eq("USA")
      end

      it "allows omitting optional nested fields" do
        params = {
          user: {
            name: "John Doe",
            address: {
              street: "123 Main St",
              city: "Boston"
            }
          }
        }

        result = NestedContract.structify(params)
        expect(result.user.address.country).to be_nil
      end
    end

    context "with array contract" do
      it "creates a struct with array types" do
        params = {
          tags: %w[ruby rails],
          scores: [85, 92, 78],
          items: [
            { id: 1, name: "Item 1" },
            { id: 2, name: "Item 2" }
          ]
        }

        result = ArrayContract.structify(params)

        expect(result.tags).to eq(%w[ruby rails])
        expect(result.scores).to eq([85, 92, 78])
        expect(result.items.size).to eq(2)
        expect(result.items.first.id).to eq(1)
        expect(result.items.first.name).to eq("Item 1")
      end

      it "validates array element types" do
        params = {
          tags: ["ruby", 123], # invalid: number in string array
          scores: [85, 92, 78],
          items: [
            { id: 1, name: "Item 1" }
          ]
        }

        expect do
          ArrayContract.structify(params)
        end.to raise_error(Mortymer::Contract::ContractError)
      end
    end

    context "with optional contract" do
      it "handles optional fields with defaults" do
        params = {
          title: "My Title"
        }

        result = OptionalContract.structify(params)

        expect(result.title).to eq("My Title")
        expect(result.description).to be_nil
        expect(result.status).to eq("pending")
        expect(result.metadata).to be_nil
      end

      it "accepts optional fields when provided" do
        params = {
          title: "My Title",
          description: "My Description",
          metadata: {
            created_at: "2024-03-30",
            updated_at: "2024-03-31"
          }
        }

        result = OptionalContract.structify(params)

        expect(result.description).to eq("My Description")
        expect(result.metadata.created_at).to eq("2024-03-30")
        expect(result.metadata.updated_at).to eq("2024-03-31")
      end
    end

    context "with enum contract" do
      it "validates enum values" do
        params = {
          role: "admin",
          priority: 1
        }

        result = EnumContract.structify(params)

        expect(result.role).to eq("admin")
        expect(result.priority).to eq(1)
      end

      it "rejects invalid enum values" do
        params = {
          role: "superadmin", # invalid role
          priority: 1
        }

        expect do
          EnumContract.structify(params)
        end.to raise_error(Mortymer::Contract::ContractError)
      end
    end

    context "with already structified input" do
      it "returns the input directly if it's already an instance of the internal struct" do
        # First create a valid struct instance
        params = {
          name: "John Doe",
          age: 30,
          active: true
        }
        struct_instance = BasicContract.structify(params)

        # Now pass that instance back to structify
        result = BasicContract.structify(struct_instance)

        # Should be the exact same object (not just equal)
        expect(result.object_id).to eq(struct_instance.object_id)
      end

      it "still validates if input is a different struct type" do
        # Create a similar but different struct class
        different_struct = Class.new(Mortymer::Model) do
          attribute :name, Mortymer::Model::String
          attribute :age, Mortymer::Model::Integer
          attribute :active, Mortymer::Model::Bool
        end

        # Create an instance of the different struct
        different_instance = different_struct.new(
          name: "John Doe",
          age: 30,
          active: true
        )

        # Should create a new struct of the correct type
        result = BasicContract.structify(different_instance)
        expect(result).to be_an_instance_of(BasicContract.__internal_struct_repr__)
        expect(result).not_to be_an_instance_of(different_struct)
      end
    end

    context "with symbol keys and values" do
      it "handles symbol keys in input" do
        params = {
          name: "John Doe",
          age: 30,
          active: true
        }

        result = BasicContract.structify(params)
        expect(result.name).to eq("John Doe")
      end

      it "handles string keys in input" do
        params = {
          "name" => "John Doe",
          "age" => 30,
          "active" => true
        }

        result = BasicContract.structify(params)
        expect(result.name).to eq("John Doe")
      end
    end
  end

  describe ".json_schema" do
    it "generates valid JSON schema for basic contract" do
      schema = BasicContract.json_schema

      expect(schema).to include(
        type: :object,
        required: include(:name, :age, :active)
      )
      expect(schema[:properties]).to include(
        name: include(type: :string),
        age: include(type: :integer),
        active: include(type: :boolean)
      )
    end

    it "generates valid JSON schema for nested contract" do
      schema = NestedContract.json_schema

      expect(schema[:properties][:user][:properties][:address]).to include(
        type: :object,
        required: include(:street, :city)
      )
    end
  end
end
