# frozen_string_literal: true

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Mortymer::StructCompiler do
  def compiler
    Mortymer::StructCompiler.new
  end

  after do
    # Clean up generated class after each test
    if Mortymer.const_defined?(compiler.instance_variable_get(:@class_name))
      Mortymer.send(:remove_const,
                    compiler.instance_variable_get(:@class_name))
    end
  end

  describe "#compile" do
    context "with object types" do
      it "creates struct with properties" do
        schema = {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "age" => { "type" => "integer" }
          },
          "required" => ["name"]
        }

        struct_class = compiler.compile(schema)
        instance = struct_class.new(name: "John", age: 30)

        expect(instance.name).to eq("John")
        expect(instance.age).to eq(30)
      end

      it "handles optional properties" do
        schema = {
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "age" => { "type" => "integer" }
          }
        }

        struct_class = compiler.compile(schema)
        instance = struct_class.new(name: "John")

        expect(instance.name).to eq("John")
        expect(instance.age).to be_nil
      end
    end

    context "with array types" do
      it "handles arrays of primitives" do
        schema = {
          "type" => "object",
          "properties" => {
            "array" => {
              "type" => "array",
              "items" => { "type" => "string" }
            }
          }
        }

        struct_class = compiler.compile(schema)
        instance = struct_class.new(array: %w[one two])

        expect(instance.array).to eq(%w[one two])
      end

      it "handles arrays of objects" do
        schema = {

          "type" => "object",
          "properties" => {
            "array" => {
              "type" => "array",
              "items" => {
                "type" => "object",
                "properties" => {
                  "name" => { "type" => "string" }
                }
              }
            }
          }
        }

        struct_class = compiler.compile(schema)
        instance = struct_class.new(array: [{ name: "John" }, { name: "Jane" }])

        expect(instance.array[0].name).to eq("John")
        expect(instance.array[1].name).to eq("Jane")
      end
    end

    context "with enum types" do
      it "handles string enums" do
        schema = {
          "type" => "object",
          "properties" => {
            "color" => {
              "type" => "string",
              "enum" => %w[red green blue]
            }
          }
        }

        struct_class = compiler.compile(schema)
        instance = struct_class.new(color: "red")

        expect(instance.color).to eq("red")
        expect { struct_class.new(color: "yellow") }.to raise_error(Dry::Struct::Error)
      end
    end

    context "from contracts schema" do
      class MyContract < Mortymer::Contract
        params do
          required(:age).value(Integer)
          required(:color).value(String.enum("red", "blue"))
          required(:array).array do
            hash do
              required(:name).value(:string)
            end
          end
        end
      end

      it "should correctly generate the struct" do
        struct_class = compiler.compile(MyContract.schema.json_schema)
        instance = struct_class.new(
          age: 10,
          color: "red",
          array: [{ name: "John" }, { name: "Jane" }]
        )

        expect(instance.age).to eq(10)
        expect(instance.color).to eq("red")
        expect(instance.array[0].name).to eq("John")
        expect(instance.array[1].name).to eq("Jane")
        expect do
          struct_class.new(age: 10, color: "yellow", array: [{ name: "John" }])
        end.to raise_error(Dry::Struct::Error)
      end
    end
  end
end
