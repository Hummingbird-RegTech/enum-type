module EnumType
  # Simple utility for creating enumeration classes from
  # attribute lists. Currently just spits out a Struct, but
  # could handle type inference in the future.
  class EnumClass
    def self.create(attributes)
      if attributes.is_a?(Array)
        create_from_array(attributes)
      elsif attributes.is_a?(Hash)
        create_from_hash(attributes)
      end
    end

    def self.create_from_array(attributes)
      attributes = [:name] + attributes
      Struct.new(*attributes)
    end

    def self.create_from_hash(attributes)
      unless attributes.key?(:name)
        raise InvalidDefinitionError, 'Missing name attribute'
      end

      klass = Class.new
      klass.send(:attr_reader, *attributes.keys)
      klass.send(:define_method, :initialize) do |*values|
        if values.length != attributes.keys.length
          raise InvalidDefinitionError, 'Wrong attribute count'
        end

        attributes.keys.each_with_index do |name, index|
          value = values[index]
          kind = attributes[name]
          raise TypeError, "Invalid type, #{value},should be #{kind}" unless value.is_a?(kind)
          instance_variable_set("@#{name}", values[index])
        end
      end
      klass
    end
  end
end
