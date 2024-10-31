# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `fiber-annotation` gem.
# Please instead update this file by running `bin/tapioca gem fiber-annotation`.


# source://fiber-annotation//lib/fiber/annotation.rb#8
class Fiber
  include ::Fiber::Annotation
  extend ::Fiber::FixBorkedKeys

  # source://fiber-annotation//lib/fiber/annotation.rb#13
  def initialize(annotation: T.unsafe(nil), **options, &block); end

  class << self
    # Annotate the current fiber with the given annotation.
    #
    # source://fiber-annotation//lib/fiber/annotation.rb#55
    def annotate(*_arg0, **_arg1, &_arg2); end
  end
end

# A mechanism for annotating fibers.
#
# source://fiber-annotation//lib/fiber/annotation.rb#10
module Fiber::Annotation
  # Annotate the current fiber with the given annotation.
  #
  # source://fiber-annotation//lib/fiber/annotation.rb#13
  def initialize(annotation: T.unsafe(nil), **options, &block); end

  # Annotate the current fiber with the given annotation.
  #
  # If a block is given, the annotation is set for the duration of the block and then restored to the previous value.
  #
  # The block form of this method should only be invoked on the current fiber.
  #
  # source://fiber-annotation//lib/fiber/annotation.rb#31
  def annotate(annotation); end

  # Get the current annotation.
  #
  # source://fiber-annotation//lib/fiber/annotation.rb#20
  def annotation; end

  # Get the current annotation.
  #
  # source://fiber-annotation//lib/fiber/annotation.rb#20
  def annotation=(_arg0); end
end