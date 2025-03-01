# frozen_string_literal: true

require_relative "utils/string_transformations"

module Morty
  # A simple dsl to declare class dependencies for injection
  module DependenciesDsl
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
      base.prepend(
        Module.new do
          def initialize(*args, **kwargs)
            send(:inject_dependencies, kwargs)
            super(*args, **kwargs)
          end
        end
      )
    end

    # Included module class methods
    module ClassMethods
      # Store dependencies for the class
      def dependencies
        @dependencies ||= []
      end

      # Declare a dependency
      # @param constant [Class] The constant to inject
      # @param as: [Symbol] The instance variable name
      def inject(constant, as: nil)
        var_name = (as || infer_var_name(constant)).to_s
        dependencies << { constant: constant, var_name: var_name }
      end

      private

      # Infer the instance variable name from the constant
      def infer_var_name(constant)
        Utils::StringTransformations.underscore(constant.name.split("::").last)
      end
    end

    # Included module instance methods
    module InstanceMethods
      private

      # Inject all declared dependencies
      # @param overrides [Hash] Optional dependency overrides for named dependencies
      def inject_dependencies(overrides = {})
        self.class.dependencies.each do |dep|
          value = if overrides.key?(dep[:var_name].to_sym)
                    overrides[dep[:var_name].to_sym]
                  else
                    Container.resolve_constant(dep[:constant])
                  end

          instance_variable_set("@#{dep[:var_name]}", value)
        rescue Container::NotFoundError => e
          raise Container::DependencyError, "Failed to inject dependency #{dep[:constant]}: #{e.message}"
        end
      end
    end
  end
end
