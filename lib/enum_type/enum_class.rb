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
      if attributes.include?(:name) ||
         attributes.include?(:value) ||
         attributes.include?('name') ||
         attributes.include?('value')
        raise InvalidDefinitionError, 'Cannot use name or value as attribute names'
      end

      attributes = %i[name value] + attributes
      klass = Class.new
      klass.send(:attr_reader, *attributes)
      klass.send(:attr_reader, :enum_type)
      klass.send(:define_method, :initialize) do |*values|
        @enum_type = values.shift
        raise InvalidDefinitionError, 'Wrong attribute count' if values.length != attributes.length

        attributes.each_with_index do |name, index|
          value = values[index]
          instance_variable_set("@#{name}", values[index])
        end
      end
      define_inspection_methods(klass)
      klass
    end

    def self.create_from_hash(attributes)
      unless attributes.key?(:value)
        raise InvalidDefinitionError, 'Missing value attribute'
      end
      # Add name attribute as a String
      attributes = { name: String }.merge!(attributes)
      klass = Class.new
      klass.send(:attr_reader, *attributes.keys)
      klass.send(:attr_reader, :enum_type)
      klass.send(:define_method, :initialize) do |*values|
        @enum_type = values.shift
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
      define_inspection_methods(klass)
      klass
    end

    def self.define_inspection_methods(klass)
      klass.send(:define_method, :to_s) do
        name.to_s
      end

      klass.send(:define_method, :inspect) do
        "\#<Enum:#{name} #{value.inspect}>"
      end
    end
    private_class_method :define_inspection_methods
  end
end
