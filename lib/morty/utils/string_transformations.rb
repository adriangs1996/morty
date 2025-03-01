# frozen_string_literal: true

module Morty
  module Utils
    # Provides string transformation utilities similar to ActiveSupport's methods
    module StringTransformations
      module_function

      def underscore(camel_cased_word)
        return camel_cased_word unless camel_cased_word.is_a?(String)

        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, "/")
        word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      def demodulize(path)
        return path unless path.is_a?(String)

        path.split("::").last
      end
    end
  end
end
