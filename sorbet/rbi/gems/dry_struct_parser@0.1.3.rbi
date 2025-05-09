# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `dry_struct_parser` gem.
# Please instead update this file by running `bin/tapioca gem dry_struct_parser`.


# source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#3
module DryStructParser; end

# source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#4
class DryStructParser::StructSchemaParser
  # @return [StructSchemaParser] a new instance of StructSchemaParser
  #
  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#19
  def initialize; end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#27
  def call(struct, &block); end

  # Returns the value of attribute keys.
  #
  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#17
  def keys; end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#23
  def to_h; end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#34
  def visit(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#100
  def visit_and(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#120
  def visit_any(_, opts); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#129
  def visit_array(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#74
  def visit_constrained(node, opts = T.unsafe(nil)); end

  # source://mortymer/0.0.13/lib/mortymer/dry_swagger.rb#17
  def visit_constructor(node, opts); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#106
  def visit_enum(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#67
  def visit_key(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#78
  def visit_nominal(_node, _opts); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#80
  def visit_predicate(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#43
  def visit_schema(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#124
  def visit_struct(node, opts = T.unsafe(nil)); end

  # source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#110
  def visit_sum(node, opts = T.unsafe(nil)); end
end

# source://dry_struct_parser//lib/dry_struct_parser/struct_schema_parser.rb#5
DryStructParser::StructSchemaParser::PREDICATE_TYPES = T.let(T.unsafe(nil), Hash)
