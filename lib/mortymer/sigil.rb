# frozen_string_literal: true

module Mortymer
  # Sigil provides symbolic type checking for input and outputs
  # of method calls using dry-types
  module Sigil
    class TypeError < StandardError; end

    # Class methods to be included as part of the dsl
    module ClassMethods
      # Store type signatures for methods before they are defined
      def sign(*positional_types, returns: nil, **keyword_types)
        @pending_type_signature = {
          positional_types: positional_types,
          keyword_types: keyword_types,
          returns: returns
        }
      end

      # Hook called when a method is defined
      def method_added(method_name)
        return super if @pending_type_signature.nil?
        return super if @processing_type_check

        signature = @pending_type_signature
        @pending_type_signature = nil

        # Get the original method
        original_method = instance_method(method_name)

        @processing_type_check = true

        # Redefine the method with type checking
        define_method(method_name) do |*args, **kwargs|
          # Validate positional arguments
          procced_args = []
          procced_kwargs = {}
          args.each_with_index do |arg, idx|
            unless (type = signature[:positional_types][idx])
              procced_args << arg
              next
            end

            begin
              procced_args << (type.respond_to?(:structify) ? type.structify(arg) : type.call(arg))
            rescue Dry::Types::CoercionError => e
              raise TypeError, "Invalid type for argument #{idx}: expected #{type}, got #{arg.class} - #{e.message}"
            end
          end

          # Validate keyword arguments
          kwargs.each do |key, value|
            unless (type = signature[:keyword_types][key])
              procced_kwargs[key] = value
              next
            end

            begin
              procced_kwargs[key] = (type.respond_to?(:structify) ? type.structify(value) : type.call(value))
            rescue Dry::Types::CoercionError => e
              raise TypeError,
                    "Invalid type for keyword argument #{key}: expected #{type}, got #{value.class} - #{e.message}"
            end
          end

          # Call the original method
          result = original_method.bind(self).call(*procced_args, **procced_kwargs)

          # Validate return type if specified
          if (return_type = signature[:returns])
            begin
              return return_type.respond_to?(:structify) ? return_type.structify(result) : return_type.call(result)
            rescue Dry::Types::CoercionError => e
              raise TypeError, "Invalid return type: expected #{return_type}, got #{result.class} - #{e.message}"
            end
          end

          result
        end

        @processing_type_check = false

        # Call super to maintain compatibility with other method hooks
        super
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
