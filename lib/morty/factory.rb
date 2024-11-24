# frozen_string_literal: true

module Morty
  # A specialized factory to instantiate objects
  # following morty conventions
  class Factory
    def initialize(context, ioc_context)
      @context = context
      @ioc_context = ioc_context
    end

    def create_instance_of_type(type)
      concrete_implementation = @ioc_context[type]
      if concrete_implementation.nil?
        impl = type.new
        impl.build(@context) if impl.respond_to?(:build)
        impl
      else
        sign = signature_for_type(concrete_implementation)
        if sign.nil? || sign.empty?
          impl = concrete_implementation.new
          impl.build(@context) if impl.respond_to?(:build)
          impl
        else
          params = {}
          sign.each do |name, meta|
            typ = meta[:type]
            concrete = @ioc_context[typ]
            if concrete.nil?
              params[name] = create_instance_of_type(typ)
            else
              target = concrete.new
              target.build(@context) if target.respond_to?(:build)
              params[name] = target
            end
          end
          result = concrete_implementation.new(**params)
          result.build(@context) if result.respond_to?(:build)
          result
        end
      end
    end

    def signature_for_type(type)
      type.props if type.respond_to?(:props)
    end
  end
end
