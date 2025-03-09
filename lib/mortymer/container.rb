# frozen_string_literal: true

require "concurrent"

module Mortymer
  # Base container for dependency injection
  class Container
    class Error < StandardError; end
    class DependencyError < Error; end
    class NotFoundError < Error; end

    class << self
      # Get the global container instance
      def instance
        @instance ||= new
      end

      # Initialize the container storage
      def registry
        instance.registry
      end

      # Create a new container with a copy of the current registry
      def duplicate
        new(registry.dup)
      end

      # Delegate instance methods to the singleton instance
      def method_missing(method_name, *args, &block)
        if instance.respond_to?(method_name)
          instance.public_send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        instance.respond_to?(method_name, include_private) || super
      end
    end

    attr_reader :registry

    def initialize(initial_registry = Concurrent::Hash.new)
      @registry = initial_registry
    end

    def duplicate
      self.class.new(registry.dup)
    end

    # Register a constant with its implementation
    # @param constant [Class] The constant to register
    # @param implementation [Object] The implementation to register
    def register_constant(constant, implementation = nil, &block)
      key = constant_to_key(constant)
      registry[key] = block || implementation
    end

    # Resolve a constant to its implementation
    # @param constant [Class] The constant to resolve
    # @param resolution_stack [Array] Stack of constants being resolved to detect cycles
    # @return [Object] The resolved implementation
    def resolve_constant(constant, resolution_stack = []) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      key = constant_to_key(constant)

      # Check for circular dependencies
      if resolution_stack.include?(key)
        raise DependencyError, "Circular dependency detected: #{resolution_stack.join(" -> ")} -> #{key}"
      end

      # Return cached instance if available
      return registry[key] if registry[key] && !registry[key].is_a?(Class) && !registry[key].is_a?(Proc)

      implementation = registry[key]

      # If not registered, try to resolve the constant from string/symbol
      if !implementation && (constant.is_a?(String) || constant.is_a?(Symbol))
        begin
          const_name = constant.to_s
          implementation = Object.const_get(const_name)
          registry[key] = implementation
        rescue NameError
          raise NotFoundError, "No implementation found for #{key}"
        end
      end

      # If not registered, try to auto-resolve the constant if it's a class
      if !implementation && constant.is_a?(Class)
        implementation = constant
        registry[key] = implementation
      end

      raise NotFoundError, "No implementation found for #{key}" unless implementation

      # Add current constant to resolution stack
      resolution_stack.push(key)

      result = resolve_implementation(implementation, key, resolution_stack)

      resolution_stack.pop
      result
    end

    private

    # Resolve the actual implementation
    def resolve_implementation(implementation, key, resolution_stack)
      case implementation
      when Proc
        result = instance_exec(&implementation)
        registry[key] = result
        result
      when Class
        resolve_class(implementation, key, resolution_stack)
      else
        implementation
      end
    end

    # Resolve a class implementation with its dependencies
    def resolve_class(klass, key, resolution_stack)
      instance = if klass.respond_to?(:dependencies)
                   inject_dependencies(klass, resolution_stack)
                 else
                   klass.new
                 end
      registry[key] = instance
      instance
    end

    # Inject dependencies into a new instance
    def inject_dependencies(klass, resolution_stack)
      deps = klass.dependencies.map do |dep|
        { var_name: dep[:var_name], value: resolve_constant(dep[:constant], resolution_stack.dup) }
      end

      instance = klass.new
      deps.each do |dep|
        instance.instance_variable_set("@#{dep[:var_name]}", dep[:value])
      end
      instance
    end

    # Convert a constant to a container registration key
    # @param constant [Class] The constant to convert
    # @return [String] The container registration key
    def constant_to_key(constant)
      key = if constant.is_a?(String) || constant.is_a?(Symbol)
              constant.to_s
            else
              constant.name
            end
      Utils::StringTransformations.underscore(key.split("::").join("_"))
    end
  end
end
