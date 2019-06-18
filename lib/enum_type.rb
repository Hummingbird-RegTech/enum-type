require 'enum_type/errors'
require 'enum_type/enum'
require 'dry-types'

# An Enum implementation that allows Enums to have typesafe
# attributes beyond a single value.
module EnumType
  def self.create(*attributes, &block)
    raise InvalidDefinitionError if block.nil?

    if attributes.first.is_a?(Hash)
      Enum.new(attributes.first, &block)
    else
      Enum.new(attributes, &block)
    end
  end
end
