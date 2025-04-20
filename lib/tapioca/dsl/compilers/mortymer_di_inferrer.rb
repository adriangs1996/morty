# frozen_string_literal: true

# typed: true

require "mortymer"

module Tapioca
  module Dsl
    module Compilers
      # Provide annotations for variables injected through DI
      class MortymerDiInferrer < Tapioca::Dsl::Compiler
        extend T::Sig

        ConstantType = type_member { { fixed: T.class_of(Mortymer::DependenciesDsl) } }

        sig { override.returns(T::Enumerable[Module]) }
        def self.gather_constants
          all_classes.select { |c| c < Mortymer::DependenciesDsl }
        end

        sig { override.void }
        def decorate
          root.create_path(constant) do |klass|
            constant.dependencies.each do |dep|
              klass.create_method(dep[:var_name], return_type: dep[:constant].to_s, visibility: RBI::Private.new)
            end
          end
        end
      end
    end
  end
end
