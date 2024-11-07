# frozen_string_literal: true
# typed: true

module Morty
  module PathDslMixin
    extend T::Generic
    has_attached_class!
    abstract!

    sig { params(suffix: T.any(Symbol, String)).void }
    def path_suffix(suffix)
      @__suffix = suffix
    end

    sig { abstract.returns(String) }
    def name; end

    def __set_resulting_path(path)
      @__resulting_path = path
    end

    sig { returns(T.nilable(String)) }
    def __resulting_path
      @__resulting_path ||= nil
    end

    def __suffix
      @__suffix ||= nil
    end
  end

  class Scope
    extend PathDslMixin
  end
end
