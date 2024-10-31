# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `sorbet-schema` gem.
# Please instead update this file by running `bin/tapioca gem sorbet-schema`.


# typed: strict

# We don't want a dependency on ActiveSupport.
# This is a simplified version of ActiveSupport's Key Hash extension
# https://github.com/rails/rails/blob/main/activesupport/lib/active_support/core_ext/hash/keys.rb
#
# source://sorbet-schema//lib/sorbet-schema/hash_transformer.rb#6
class HashTransformer
  class << self
    # source://sorbet-schema//lib/sorbet-schema/hash_transformer.rb#18
    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[T.untyped, T.untyped]) }
    def serialize_values(hash); end

    # source://sorbet-schema//lib/sorbet-schema/hash_transformer.rb#11
    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[::Symbol, T.untyped]) }
    def symbolize_keys(hash); end
  end
end

# source://sorbet-schema//lib/sorbet-schema/serialize_value.rb#3
class SerializeValue
  class << self
    # source://sorbet-schema//lib/sorbet-schema/serialize_value.rb#7
    sig { params(value: T.untyped).returns(T.untyped) }
    def serialize(value); end
  end
end

# source://sorbet-schema//lib/sorbet-schema/t/struct.rb#4
class T::Struct < ::T::InexactStruct
  # source://sorbet-schema//lib/sorbet-schema/t/struct.rb#26
  sig do
    params(
      serializer_type: Symbol,
      options: T::Hash[Symbol, T.untyped]
    ).returns(Typed::Result[T.untyped, Typed::SerializeError])
  end
  def serialize_to(serializer_type, options: T.unsafe(nil)); end

  class << self
    # source://sorbet-schema//lib/sorbet-schema/t/struct.rb#21
    sig do
      params(
        serializer_type: Symbol,
        source: T.untyped,
        options: T::Hash[Symbol, T.untyped]
      ).returns(Typed::Result[T.attached_class, Typed::DeserializeError])
    end
    def deserialize_from(serializer_type, source, options: T.unsafe(nil)); end

    # source://sorbet-schema//lib/sorbet-schema/t/struct.rb#6
    sig { overridable.returns(Typed::Schema) }
    def schema; end

    # source://sorbet-schema//lib/sorbet-schema/t/struct.rb#10
    sig { params(type: Symbol, options: T::Hash[Symbol, T.untyped]).returns(Typed::Serializer[T.untyped, T.untyped]) }
    def serializer(type, options: T.unsafe(nil)); end
  end
end

# source://sorbet-schema//lib/sorbet-schema.rb#32
module Typed; end

# source://sorbet-schema//lib/typed/coercion.rb#4
module Typed::Coercion
  class << self
    # source://sorbet-schema//lib/typed/coercion.rb#13
    sig do
      params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[T.untyped, ::Typed::Coercion::CoercionError])
    end
    def coerce(type:, value:); end

    # source://sorbet-schema//lib/typed/coercion.rb#8
    sig { params(coercer: T.class_of(Typed::Coercion::Coercer)).void }
    def register_coercer(coercer); end
  end
end

# source://sorbet-schema//lib/typed/coercion/boolean_coercer.rb#5
class Typed::Coercion::BooleanCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: T::Boolean } }

  # source://sorbet-schema//lib/typed/coercion/boolean_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/boolean_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# @abstract It cannot be directly instantiated. Subclasses must implement the `abstract` methods below.
#
# source://sorbet-schema//lib/typed/coercion/coercer.rb#5
class Typed::Coercion::Coercer
  extend T::Generic

  abstract!

  Target = type_member(:out)

  # @abstract
  #
  # source://sorbet-schema//lib/typed/coercion/coercer.rb#18
  sig do
    abstract
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # @abstract
  #
  # source://sorbet-schema//lib/typed/coercion/coercer.rb#14
  sig { abstract.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#7
class Typed::Coercion::CoercerRegistry
  include ::Singleton
  extend ::Singleton::SingletonClassMethods

  # source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#32
  sig { void }
  def initialize; end

  # source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#37
  sig { params(coercer: T.class_of(Typed::Coercion::Coercer)).void }
  def register(coercer); end

  # source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#42
  sig { void }
  def reset!; end

  # source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#47
  sig { params(type: ::T::Types::Base).returns(T.nilable(T.class_of(Typed::Coercion::Coercer))) }
  def select_coercer_by(type:); end

  class << self
    private

    def allocate; end
    def new(*_arg0); end
  end
end

# source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#14
Typed::Coercion::CoercerRegistry::DEFAULT_COERCERS = T.let(T.unsafe(nil), Array)

# source://sorbet-schema//lib/typed/coercion/coercer_registry.rb#12
Typed::Coercion::CoercerRegistry::Registry = T.type_alias { T::Array[T.class_of(Typed::Coercion::Coercer)] }

# source://sorbet-schema//lib/typed/coercion/coercion_error.rb#5
class Typed::Coercion::CoercionError < ::StandardError; end

# source://sorbet-schema//lib/typed/coercion/coercion_not_supported_error.rb#5
class Typed::Coercion::CoercionNotSupportedError < ::Typed::Coercion::CoercionError
  # source://sorbet-schema//lib/typed/coercion/coercion_not_supported_error.rb#9
  sig { params(type: ::T::Types::Base).void }
  def initialize(type:); end
end

# source://sorbet-schema//lib/typed/coercion/date_coercer.rb#7
class Typed::Coercion::DateCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: Date } }

  # source://sorbet-schema//lib/typed/coercion/date_coercer.rb#18
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/date_coercer.rb#13
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/date_time_coercer.rb#7
class Typed::Coercion::DateTimeCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: DateTime } }

  # source://sorbet-schema//lib/typed/coercion/date_time_coercer.rb#18
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/date_time_coercer.rb#13
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/enum_coercer.rb#5
class Typed::Coercion::EnumCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: T::Enum } }

  # source://sorbet-schema//lib/typed/coercion/enum_coercer.rb#18
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/enum_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/float_coercer.rb#5
class Typed::Coercion::FloatCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: Float } }

  # source://sorbet-schema//lib/typed/coercion/float_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/float_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/integer_coercer.rb#5
class Typed::Coercion::IntegerCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: Integer } }

  # source://sorbet-schema//lib/typed/coercion/integer_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/integer_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/string_coercer.rb#5
class Typed::Coercion::StringCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: String } }

  # source://sorbet-schema//lib/typed/coercion/string_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/string_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/struct_coercer.rb#5
class Typed::Coercion::StructCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: T::Struct } }

  # source://sorbet-schema//lib/typed/coercion/struct_coercer.rb#18
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/struct_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/symbol_coercer.rb#5
class Typed::Coercion::SymbolCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: Symbol } }

  # source://sorbet-schema//lib/typed/coercion/symbol_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/symbol_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/typed_array_coercer.rb#5
class Typed::Coercion::TypedArrayCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: T::Array[T.untyped] } }

  # source://sorbet-schema//lib/typed/coercion/typed_array_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/typed_array_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/coercion/typed_hash_coercer.rb#5
class Typed::Coercion::TypedHashCoercer < ::Typed::Coercion::Coercer
  extend T::Generic

  Target = type_member { { fixed: T::Hash[T.untyped, T.untyped] } }

  # source://sorbet-schema//lib/typed/coercion/typed_hash_coercer.rb#16
  sig do
    override
      .params(
        type: ::T::Types::Base,
        value: T.untyped
      ).returns(Typed::Result[Target, ::Typed::Coercion::CoercionError])
  end
  def coerce(type:, value:); end

  # source://sorbet-schema//lib/typed/coercion/typed_hash_coercer.rb#11
  sig { override.params(type: ::T::Types::Base).returns(T::Boolean) }
  def used_for_type?(type); end
end

# source://sorbet-schema//lib/typed/deserialize_error.rb#4
class Typed::DeserializeError < ::Typed::SerializationError
  # source://sorbet-schema//lib/typed/deserialize_error.rb#8
  sig { returns({error: ::String}) }
  def to_h; end

  # source://sorbet-schema//lib/typed/deserialize_error.rb#13
  sig { params(_options: T::Hash[T.untyped, T.untyped]).returns(::String) }
  def to_json(_options = T.unsafe(nil)); end
end

# source://sorbet-schema//lib/typed/field.rb#4
class Typed::Field
  # source://sorbet-schema//lib/typed/field.rb#33
  sig do
    params(
      name: ::Symbol,
      type: T.any(::T::Types::Base, T::Class[T.anything]),
      optional: T::Boolean,
      default: T.untyped,
      inline_serializer: T.nilable(T.proc.params(arg0: T.untyped).returns(T.untyped))
    ).void
  end
  def initialize(name:, type:, optional: T.unsafe(nil), default: T.unsafe(nil), inline_serializer: T.unsafe(nil)); end

  # source://sorbet-schema//lib/typed/field.rb#61
  sig { params(other: ::Typed::Field).returns(T.nilable(T::Boolean)) }
  def ==(other); end

  # source://sorbet-schema//lib/typed/field.rb#16
  sig { returns(T.untyped) }
  def default; end

  # source://sorbet-schema//lib/typed/field.rb#22
  sig { returns(T.nilable(T.proc.params(arg0: T.untyped).returns(T.untyped))) }
  def inline_serializer; end

  # source://sorbet-schema//lib/typed/field.rb#10
  sig { returns(::Symbol) }
  def name; end

  # source://sorbet-schema//lib/typed/field.rb#75
  sig { returns(T::Boolean) }
  def optional?; end

  # source://sorbet-schema//lib/typed/field.rb#19
  sig { returns(T::Boolean) }
  def required; end

  # source://sorbet-schema//lib/typed/field.rb#70
  sig { returns(T::Boolean) }
  def required?; end

  # source://sorbet-schema//lib/typed/field.rb#80
  sig { params(value: T.untyped).returns(T.untyped) }
  def serialize(value); end

  # source://sorbet-schema//lib/typed/field.rb#13
  sig { returns(::T::Types::Base) }
  def type; end

  # source://sorbet-schema//lib/typed/field.rb#89
  sig do
    params(
      value: T.untyped
    ).returns(Typed::Result[::Typed::Validations::ValidatedValue, ::Typed::Validations::ValidationError])
  end
  def validate(value); end

  # source://sorbet-schema//lib/typed/field.rb#94
  sig { params(value: T.untyped).returns(T::Boolean) }
  def works_with?(value); end
end

# source://sorbet-schema//lib/typed/field.rb#7
Typed::Field::InlineSerializer = T.type_alias { T.proc.params(arg0: T.untyped).returns(T.untyped) }

# source://sorbet-schema//lib/typed/hash_serializer.rb#4
class Typed::HashSerializer < ::Typed::Serializer
  extend T::Generic

  Input = type_member { { fixed: T::Hash[T.any(::String, ::Symbol), T.untyped] } }
  Output = type_member { { fixed: T::Hash[::Symbol, T.untyped] } }

  # source://sorbet-schema//lib/typed/hash_serializer.rb#13
  sig { params(schema: ::Typed::Schema, should_serialize_values: T::Boolean).void }
  def initialize(schema:, should_serialize_values: T.unsafe(nil)); end

  # source://sorbet-schema//lib/typed/hash_serializer.rb#20
  sig { override.params(source: Input).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError]) }
  def deserialize(source); end

  # source://sorbet-schema//lib/typed/hash_serializer.rb#25
  sig { override.params(struct: ::T::Struct).returns(Typed::Result[Output, ::Typed::SerializeError]) }
  def serialize(struct); end

  # source://sorbet-schema//lib/typed/hash_serializer.rb#10
  sig { returns(T::Boolean) }
  def should_serialize_values; end
end

# source://sorbet-schema//lib/typed/hash_serializer.rb#5
Typed::HashSerializer::InputHash = T.type_alias { T::Hash[T.any(::String, ::Symbol), T.untyped] }

# source://sorbet-schema//lib/typed/json_serializer.rb#6
class Typed::JSONSerializer < ::Typed::Serializer
  extend T::Generic

  Input = type_member { { fixed: String } }
  Output = type_member { { fixed: String } }

  # source://sorbet-schema//lib/typed/json_serializer.rb#11
  sig { override.params(source: Input).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError]) }
  def deserialize(source); end

  # source://sorbet-schema//lib/typed/json_serializer.rb#24
  sig { override.params(struct: ::T::Struct).returns(Typed::Result[Output, ::Typed::SerializeError]) }
  def serialize(struct); end
end

# source://sorbet-schema//lib/typed/parse_error.rb#4
class Typed::ParseError < ::Typed::DeserializeError
  # source://sorbet-schema//lib/typed/parse_error.rb#8
  sig { params(format: ::Symbol).void }
  def initialize(format:); end
end

# source://sorbet-schema//lib/typed/schema.rb#4
class Typed::Schema < ::T::Struct
  include ::Comparable

  const :fields, T::Array[::Typed::Field], default: T.unsafe(nil)
  const :target, T.class_of(T::Struct)

  # source://sorbet-schema//lib/typed/schema.rb#32
  sig do
    params(
      field_name: ::Symbol,
      serializer: T.proc.params(arg0: T.untyped).returns(T.untyped)
    ).returns(::Typed::Schema)
  end
  def add_serializer(field_name, serializer); end

  # source://sorbet-schema//lib/typed/schema.rb#22
  sig do
    params(
      hash: T::Hash[T.any(::String, ::Symbol), T.untyped]
    ).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError])
  end
  def from_hash(hash); end

  # source://sorbet-schema//lib/typed/schema.rb#27
  sig { params(json: ::String).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError]) }
  def from_json(json); end

  class << self
    # source://sorbet-schema//lib/typed/schema.rb#12
    sig { params(struct: T.class_of(T::Struct)).returns(::Typed::Schema) }
    def from_struct(struct); end

    # source://sorbet-runtime/0.5.11618/lib/types/struct.rb#13
    def inherited(s); end
  end
end

# source://sorbet-schema//lib/typed/serialization_error.rb#4
class Typed::SerializationError < ::StandardError
  # source://sorbet-schema//lib/typed/serialization_error.rb#8
  sig { returns({error: ::String}) }
  def to_h; end

  # source://sorbet-schema//lib/typed/serialization_error.rb#13
  sig { params(_options: T::Hash[T.untyped, T.untyped]).returns(::String) }
  def to_json(_options = T.unsafe(nil)); end
end

# source://sorbet-schema//lib/typed/serialize_error.rb#4
class Typed::SerializeError < ::Typed::SerializationError; end

# @abstract It cannot be directly instantiated. Subclasses must implement the `abstract` methods below.
#
# source://sorbet-schema//lib/typed/serializer.rb#4
class Typed::Serializer
  extend T::Generic

  abstract!

  Input = type_member
  Output = type_member

  # source://sorbet-schema//lib/typed/serializer.rb#19
  sig { params(schema: ::Typed::Schema).void }
  def initialize(schema:); end

  # @abstract
  #
  # source://sorbet-schema//lib/typed/serializer.rb#24
  sig { abstract.params(source: Input).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError]) }
  def deserialize(source); end

  # source://sorbet-schema//lib/typed/serializer.rb#16
  sig { returns(::Typed::Schema) }
  def schema; end

  # @abstract
  #
  # source://sorbet-schema//lib/typed/serializer.rb#28
  sig { abstract.params(struct: ::T::Struct).returns(Typed::Result[Output, ::Typed::SerializeError]) }
  def serialize(struct); end

  private

  # source://sorbet-schema//lib/typed/serializer.rb#34
  sig do
    params(
      creation_params: T::Hash[::Symbol, T.untyped]
    ).returns(Typed::Result[::T::Struct, ::Typed::DeserializeError])
  end
  def deserialize_from_creation_params(creation_params); end

  # source://sorbet-schema//lib/typed/serializer.rb#84
  sig { params(struct: ::T::Struct, should_serialize_values: T::Boolean).returns(T::Hash[::Symbol, T.untyped]) }
  def serialize_from_struct(struct:, should_serialize_values: T.unsafe(nil)); end
end

# source://sorbet-schema//lib/typed/serializer.rb#13
Typed::Serializer::DeserializeResult = T.type_alias { Typed::Result[::T::Struct, ::Typed::DeserializeError] }

# source://sorbet-schema//lib/typed/serializer.rb#12
Typed::Serializer::Params = T.type_alias { T::Hash[::Symbol, T.untyped] }

# source://sorbet-schema//lib/typed/validations.rb#4
module Typed::Validations; end

# source://sorbet-schema//lib/typed/validations/field_type_validator.rb#5
class Typed::Validations::FieldTypeValidator
  include ::Typed::Validations::FieldValidator

  # source://sorbet-schema//lib/typed/validations/field_type_validator.rb#11
  sig do
    override
      .params(
        field: ::Typed::Field,
        value: T.untyped
      ).returns(Typed::Result[::Typed::Validations::ValidatedValue, ::Typed::Validations::ValidationError])
  end
  def validate(field:, value:); end
end

# @abstract Subclasses must implement the `abstract` methods below.
#
# source://sorbet-schema//lib/typed/validations/field_validator.rb#5
module Typed::Validations::FieldValidator
  interface!

  # @abstract
  #
  # source://sorbet-schema//lib/typed/validations/field_validator.rb#11
  sig do
    abstract
      .params(
        field: ::Typed::Field,
        value: T.untyped
      ).returns(Typed::Result[::Typed::Validations::ValidatedValue, ::Typed::Validations::ValidationError])
  end
  def validate(field:, value:); end
end

# source://sorbet-schema//lib/typed/validations/multiple_validation_error.rb#5
class Typed::Validations::MultipleValidationError < ::Typed::Validations::ValidationError
  # source://sorbet-schema//lib/typed/validations/multiple_validation_error.rb#9
  sig { params(errors: T::Array[::Typed::Validations::ValidationError]).void }
  def initialize(errors:); end
end

# source://sorbet-schema//lib/typed/validations/required_field_error.rb#5
class Typed::Validations::RequiredFieldError < ::Typed::Validations::ValidationError
  # source://sorbet-schema//lib/typed/validations/required_field_error.rb#9
  sig { params(field_name: ::Symbol).void }
  def initialize(field_name:); end
end

# source://sorbet-schema//lib/typed/validations/type_mismatch_error.rb#5
class Typed::Validations::TypeMismatchError < ::Typed::Validations::ValidationError
  # source://sorbet-schema//lib/typed/validations/type_mismatch_error.rb#9
  sig { params(field_name: ::Symbol, field_type: ::T::Types::Base, given_type: T::Class[T.anything]).void }
  def initialize(field_name:, field_type:, given_type:); end
end

# source://sorbet-schema//lib/typed/validations.rb#6
Typed::Validations::ValidatedParams = T.type_alias { T::Hash[::Symbol, T.untyped] }

# source://sorbet-schema//lib/typed/validations/validated_value.rb#5
class Typed::Validations::ValidatedValue < ::T::Struct
  include ::Comparable

  const :name, ::Symbol
  const :value, T.untyped

  class << self
    # source://sorbet-runtime/0.5.11618/lib/types/struct.rb#13
    def inherited(s); end
  end
end

# source://sorbet-schema//lib/typed/validations/validation_error.rb#5
class Typed::Validations::ValidationError < ::Typed::DeserializeError; end

# source://sorbet-schema//lib/typed/validations.rb#5
Typed::Validations::ValidationResult = T.type_alias { Typed::Result[::Typed::Validations::ValidatedValue, ::Typed::Validations::ValidationError] }

# source://sorbet-schema//lib/typed/validations/validation_results.rb#5
class Typed::Validations::ValidationResults < ::T::Struct
  const :results, T::Array[Typed::Result[::Typed::Validations::ValidatedValue, ::Typed::Validations::ValidationError]]

  # source://sorbet-schema//lib/typed/validations/validation_results.rb#11
  sig { returns(Typed::Result[T::Hash[::Symbol, T.untyped], ::Typed::Validations::ValidationError]) }
  def combine; end

  class << self
    # source://sorbet-runtime/0.5.11618/lib/types/struct.rb#13
    def inherited(s); end
  end
end

# source://sorbet-schema//lib/sorbet-schema.rb#33
Typed::Value = T.type_alias { T.untyped }
