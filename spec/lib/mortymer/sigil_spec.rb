# frozen_string_literal: true

require "spec_helper"
require "dry-types"

module Types
  include Dry::Types()
end

class MyModel < Mortymer::Model
  attribute :age, Integer
end

class MyExampleContract < Mortymer::Contract
  params do
    required(:age).value(Integer, gt?: 10)
  end
end

class TestClass
  include Mortymer::Sigil

  sign MyModel, returns: MyModel
  def pass_model(model)
    MyModel.new(age: model.age * 2)
  end

  sign(Types::Integer, Types::String, returns: Types::Integer)
  def add_length(num, str)
    num + str.length
  end

  sign(name: Types::String, age: Types::Integer, returns: Types::Hash)
  def person_info(name:, age:)
    { name: name, age: age }
  end

  sign(Types::Array.of(Types::Integer), returns: Types::Integer)
  def sum_array(numbers)
    numbers.sum
  end

  # Method without type checking
  def untyped_method(value)
    value
  end

  sign(Types::String)
  def no_return_type(str)
    str.upcase
  end
end

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Mortymer::Sigil do # rubocop:disable Metrics/BlockLength
  let(:test_instance) { TestClass.new }

  describe "Model and Contract integration" do
    context "with an instance of model" do
      it "should not throw an error" do
        expect { test_instance.pass_model(MyModel.new(age: 20)) }.not_to raise_error
        expect(test_instance.pass_model(MyModel.new(age: 20)).age).to eq(40)
        expect(test_instance.pass_model(MyModel.new(age: 20))).to be_a(MyModel)
      end
    end

    context "with an input hash" do
      it "should coerce input" do
        expect { test_instance.pass_model({ age: 20 }) }.not_to raise_error
        expect(test_instance.pass_model({ age: 20 }).age).to eq(40)
        expect(test_instance.pass_model({ age: 20 })).to be_a(MyModel)
      end
    end
  end

  describe "positional argument type checking" do
    context "with valid types" do
      it "allows valid argument types" do
        expect { test_instance.add_length(5, "hello") }.not_to raise_error
      end

      it "returns the correct value" do
        expect(test_instance.add_length(5, "hello")).to eq(10)
      end
    end

    context "with invalid types" do
      it "raises TypeError for first argument" do
        expect { test_instance.add_length("5", "hello") }
          .to raise_error(Mortymer::Sigil::TypeError, /Invalid type for argument 0/)
      end

      it "raises TypeError for second argument" do
        expect { test_instance.add_length(5, 123) }
          .to raise_error(Mortymer::Sigil::TypeError, /Invalid type for argument 1/)
      end
    end
  end

  describe "keyword argument type checking" do
    context "with valid types" do
      it "allows valid keyword argument types" do
        expect do
          test_instance.person_info(name: "John", age: 30)
        end.not_to raise_error
      end

      it "returns the correct value" do
        result = test_instance.person_info(name: "John", age: 30)
        expect(result).to eq({ name: "John", age: 30 })
      end
    end

    context "with invalid types" do
      it "raises TypeError for invalid name type" do
        expect do
          test_instance.person_info(name: 123, age: 30)
        end.to raise_error(Mortymer::Sigil::TypeError, /Invalid type for keyword argument name/)
      end

      it "raises TypeError for invalid age type" do
        expect do
          test_instance.person_info(name: "John", age: "30")
        end.to raise_error(Mortymer::Sigil::TypeError, /Invalid type for keyword argument age/)
      end
    end
  end

  describe "return type checking" do
    context "with valid return type" do
      it "allows valid return type" do
        expect { test_instance.add_length(5, "hello") }.not_to raise_error
      end
    end

    context "with invalid return type" do
      class InvalidReturnClass
        include Mortymer::Sigil

        sign(returns: Types::String)
        def invalid_return
          42 # Returns Integer when String is expected
        end
      end

      it "raises TypeError for invalid return type" do
        instance = InvalidReturnClass.new
        expect { instance.invalid_return }
          .to raise_error(Mortymer::Sigil::TypeError, /Invalid return type/)
      end
    end
  end

  describe "array type checking" do
    it "allows arrays of correct type" do
      expect { test_instance.sum_array([1, 2, 3]) }.not_to raise_error
      expect(test_instance.sum_array([1, 2, 3])).to eq(6)
    end

    it "raises TypeError for invalid array elements" do
      expect { test_instance.sum_array([1, "2", 3]) }
        .to raise_error(Mortymer::Sigil::TypeError)
    end
  end

  describe "methods without type checking" do
    it "allows any type for untyped methods" do
      expect { test_instance.untyped_method(123) }.not_to raise_error
      expect { test_instance.untyped_method("string") }.not_to raise_error
      expect { test_instance.untyped_method([1, 2, 3]) }.not_to raise_error
    end
  end

  describe "methods without return type" do
    it "allows any return type when return type is not specified" do
      expect { test_instance.no_return_type("hello") }.not_to raise_error
      expect(test_instance.no_return_type("hello")).to eq("HELLO")
    end
  end

  describe "method hook compatibility" do
    it "maintains the method hook chain" do
      class HookTestClass
        include Mortymer::Sigil

        def self.method_added(name)
          super
          @hook_called = true
        end

        def self.hook_called?
          @hook_called
        end

        sign(Types::String)
        def test_method(str)
          str
        end
      end

      expect(HookTestClass.hook_called?).to be true
    end
  end
end
