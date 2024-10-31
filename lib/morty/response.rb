# frozen_string_literal: true
# typed: true

require "sorbet-runtime"

module Morty
  module Response
    extend T::Sig
    extend T::Helpers
    interface!

    sig { abstract.returns(String) }
    def render; end
  end
end
