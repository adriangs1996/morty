# frozen_string_literal: true

RSpec.describe "Compile Sorbet Structs to json schema" do # rubocop:disable Metrics/BlockLength
  context "Flatten classes with builtin properties" do # rubocop:disable Metrics/BlockLength
    class FlatTestStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :const_a, Integer
      const :const_a_nil, T.nilable(Integer), default: nil
      const :const_string, String
      const :const_bool, T::Boolean
      const :const_float, Float
      const :const_symbol, Symbol
    end

    it "should output the correct json schema object" do # rubocop:disable Metrics/BlockLength
      expected_schema = {
        type: :object,
        properties: {
          const_a: {
            type: :integer,
            nullable: false
          },
          const_a_nil: {
            type: :integer,
            nullable: true
          },
          const_string: {
            type: :string,
            nullable: false
          },
          const_bool: {
            type: :boolean,
            nullable: false
          },
          const_float: {
            type: :float,
            nullable: false
          },
          const_symbol: {
            type: :string,
            nullable: false
          }
        },
        required: %i[const_a const_string const_bool const_float const_symbol]
      }

      expect(FlatTestStruct.json_schema).to eq(expected_schema)
    end
  end

  context "Nested structs" do # rubocop:disable Metrics/BlockLength
    class NestedChildStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :child_int, Integer
      const :child_string, String
      const :child_optional, T.nilable(String), default: nil
    end

    class NestedParentStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :parent_bool, T::Boolean
      const :nested_child, NestedChildStruct
      const :optional_child, T.nilable(NestedChildStruct), default: nil
    end

    it "should correctly handle nested struct schemas" do # rubocop:disable Metrics/BlockLength
      expected_schema = {
        type: :object,
        properties: {
          parent_bool: {
            type: :boolean,
            nullable: false
          },
          nested_child: {
            type: :object,
            properties: {
              child_int: {
                type: :integer,
                nullable: false
              },
              child_string: {
                type: :string,
                nullable: false
              },
              child_optional: {
                type: :string,
                nullable: true
              }
            },
            required: %i[child_int child_string],
            nullable: false
          },
          optional_child: {
            type: :object,
            properties: {
              child_int: {
                type: :integer,
                nullable: false
              },
              child_string: {
                type: :string,
                nullable: false
              },
              child_optional: {
                type: :string,
                nullable: true
              }
            },
            required: %i[child_int child_string],
            nullable: true
          }
        },
        required: %i[parent_bool nested_child]
      }

      expect(NestedParentStruct.json_schema).to eq(expected_schema)
    end
  end

  context "Array properties" do # rubocop:disable Metrics/BlockLength
    class ArrayPrimitiveStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :string_array, T::Array[String]
      const :integer_array, T::Array[Integer]
      const :optional_array, T.nilable(T::Array[Float]), default: nil
    end

    class SimpleItemStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :name, String
      const :value, Integer
    end

    class ArrayOfStructsStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :items, T::Array[SimpleItemStruct]
      const :optional_items, T.nilable(T::Array[SimpleItemStruct]), default: nil
    end

    class NestedArrayStruct < T::Struct # rubocop:disable Lint/ConstantDefinitionInBlock
      const :matrix, T::Array[T::Array[Integer]]
      const :complex_matrix, T::Array[T::Array[SimpleItemStruct]]
    end

    it "should correctly handle arrays of primitive types" do
      expected_schema = {
        type: :object,
        properties: {
          string_array: {
            type: :array,
            items: {
              type: :string
            },
            nullable: false
          },
          integer_array: {
            type: :array,
            items: {
              type: :integer
            },
            nullable: false
          },
          optional_array: {
            type: :array,
            items: {
              type: :float
            },
            nullable: true
          }
        },
        required: %i[string_array integer_array]
      }

      expect(ArrayPrimitiveStruct.json_schema).to eq(expected_schema)
    end

    it "should correctly handle arrays of structs" do
      expected_schema = {
        type: :object,
        properties: {
          items: {
            type: :array,
            items: {
              type: :object,
              properties: {
                name: {
                  type: :string,
                  nullable: false
                },
                value: {
                  type: :integer,
                  nullable: false
                }
              },
              required: %i[name value]
            },
            nullable: false
          },
          optional_items: {
            type: :array,
            items: {
              type: :object,
              properties: {
                name: {
                  type: :string,
                  nullable: false
                },
                value: {
                  type: :integer,
                  nullable: false
                }
              },
              required: %i[name value]
            },
            nullable: true
          }
        },
        required: %i[items]
      }

      expect(ArrayOfStructsStruct.json_schema).to eq(expected_schema)
    end

    it "should correctly handle nested arrays" do
      expected_schema = {
        type: :object,
        properties: {
          matrix: {
            type: :array,
            items: {
              type: :array,
              items: {
                type: :integer
              }
            },
            nullable: false
          },
          complex_matrix: {
            type: :array,
            items: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  name: {
                    type: :string,
                    nullable: false
                  },
                  value: {
                    type: :integer,
                    nullable: false
                  }
                },
                required: %i[name value]
              }
            },
            nullable: false
          }
        },
        required: %i[matrix complex_matrix]
      }

      expect(NestedArrayStruct.json_schema).to eq(expected_schema)
    end
  end
end
