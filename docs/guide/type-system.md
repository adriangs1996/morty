# Mortymer Type System Guide

## Overview

Mortymer provides a way to enforce the types contracts for inputs and
outputs of your methods through the `Sigil` module that leverages `dry-types`
to enable runtime type checking. Not only that, but, it also will try to coerce
the given parameters to the declared type, and will check validation contracts
and rules for your inputs and outputs. This is not intended to be a replacement
for Type Checkers like Sorbet or Steep, but rather a nice utility to avoid guard
code like:

```ruby
def func(params)
  result = MyContract.new.call(params)
  if result.errors.empty?
    result[:age].to_i + 10
  else
    raise StandardError, result.errors
  end
end
```

The above snippet is really common when dealing with validation (you may use `#instance_of?` method as well,
or strong parameters or whatever, but the essence is that you need to declare the shape of the data
that comes in and out of your methods).

Using Mortymer's Sigil, the above will translate to pretty much the following code:

```ruby
sign MyContract
def func(params)
  params.age + 10
end

func(MyContract.structify({age: 10})) # Will work
func(age: 10)  # Will work, the params would be { age: 10 } which will be coerced and validated with MyCotnract
func(age: "10") # Will also work, if MyContract is Coercing the age to Integer
func(age: "asd") # will raise a meaningful error
```

## Basic Usage

### Method Type Signatures

The most basic form of type checking in Mortymer uses the `sign` directive:

```ruby
class Calculator
  include Mortymer::Sigil

  sign Types::Integer, Types::Integer, returns: Types::Integer
  def add(a, b)
    a + b
  end
end
```

When you include `Mortymer::Sigil`, you get access to the `sign` directive. This will:

1. Check the types of all arguments when the method is called
2. Verify the return type matches the specified type
3. Raise a `TypeError` if any type mismatch occurs

### Keyword Arguments

You can specify types for keyword arguments using a hash syntax:

```ruby
class UserService
  include Mortymer::Sigil

  sign name: Types::String, age: Types::Integer, returns: Types::Hash
  def create_user(name:, age:)
    { name: name, age: age }
  end
end
```

### Array Types

Mortymer supports type checking for arrays of specific types:

```ruby
class Calculator
  include Mortymer::Sigil

  sign Types::Array.of(Types::Integer), returns: Types::Integer
  def sum(numbers)
    numbers.sum
  end
end
```

## Advanced Usage

### Contract Integration

Mortymer's type system integrates seamlessly with Contracts for more complex validations:

```ruby
class AgeContract < Mortymer::Contract
  params do
    required(:age).value(Integer, gt?: 10)
  end
  compile!
end

class UserService
  include Mortymer::Sigil

  sign AgeContract, returns: Types::Hash
  def process_age(params)
    { processed_age: params.age * 2 }
  end
end
```

### Model Integration

The type system works directly with Mortymer Models:

```ruby
class User < Mortymer::Model
  attribute :name, String
  attribute :age, Integer
end

class UserService
  include Mortymer::Sigil

  sign User, returns: User
  def double_age(user)
    User.new(name: user.name, age: user.age * 2)
  end
end
```

### Optional Return Types

You can omit the return type if you don't want to enforce it:

```ruby
class StringService
  include Mortymer::Sigil

  sign Types::String
  def uppercase(str)
    str.upcase
  end
end
```

### Type Coercion

The type system will attempt to coerce values when possible:

```ruby
class UserService
  include Mortymer::Sigil

  sign User, returns: User
  def process_user(user_data)
    # Will coerce a hash into a User model
    user = user_data.is_a?(User) ? user_data : User.new(user_data)
    User.new(name: user.name.upcase, age: user.age)
  end
end
```

## Error Handling

When type checking fails, Mortymer raises descriptive errors:

- `Mortymer::Sigil::TypeError` for type mismatches
- `Mortymer::Contract::ContractError` for contract violations

Example error messages:

- "Invalid type for argument 0: expected Integer, got String"
- "Invalid type for keyword argument name: expected String, got Integer"
- "Invalid return type: expected String, got Integer"

## Best Practices

1. **Be Explicit**: Always specify types for critical method parameters
2. **Use Contracts**: For complex validations, combine with Mortymer Contracts
3. **Return Types**: Specify return types when the output type is important
4. **Model Integration**: Use Mortymer Models for structured data
5. **Error Handling**: Handle type errors at appropriate boundaries in your application

## Type System Compatibility

The type system maintains compatibility with other method hooks and Ruby features:

```ruby
class Service
  include Mortymer::Sigil
  include OtherModule # with method_added hooks

  sign Types::String, returns: Types::String
  def process(str)
    str.upcase
  end
end
```

The type system will properly chain method hooks while maintaining type checking functionality.
