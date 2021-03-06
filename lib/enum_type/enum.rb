require 'enum_type/errors'
require 'enum_type/enum_class'

module EnumType
  # An Enum representation. Initialized by EnumType.create.
  class Enum
    # Context object for evaluating the Enum block.
    # Uses method_missing to collect enum definitions
    class Context
      attr_reader :enums, :enums_by_value

      def initialize(enum_klass, enum_type)
        @enum_klass = enum_klass
        @enum_type = enum_type
        @enums = {}
        @enums_by_value = {}
      end

      def respond_to_missing?(method_name, *arguments, &block)
        method_name =~ /[A-Z]+/ && block.nil? || super
      end

      def method_missing(method_name, *arguments, &block)
        if method_name =~ /[A-Z]+/ && !@enums.key?(method_name)
          raise InvalidDefinitionError, 'Missing enum value' if arguments.empty?
          raise InvalidDefinitionError, 'Cannot provide a block to an enum' unless block.nil?

          enum = @enum_klass.new(*arguments.unshift(@enum_type, method_name.to_s))
          @enums[method_name] = enum
          if @enums_by_value[enum.value]
            raise DuplicateDefinitionError,
                  "Already initialized #{@enums_by_value[enum.value].name} with value #{enum.value}"
          end
          @enums_by_value[enum.value] = enum
        elsif @enums.key?(method_name)
          raise DuplicateDefinitionError, "Already initialized #{method_name}"
        elsif method_name !~ /[A-Z]+/
          raise InvalidDefinitionError, 'Cannot use lowercase letters in enum name'
        else
          super
        end
      end
    end

    include Enumerable

    def initialize(attributes, &block)
      enum_class = EnumClass.create(attributes)
      context = Context.new(enum_class, self)
      context.instance_eval(&block)
      raise InvalidDefinitionError, 'Must define an enumeration' if context.enums.empty?

      @enums = context.enums
      @enums_by_value = context.enums_by_value
      context.enums.each do |name, value|
        define_singleton_method(name) do
          value
        end
      end
    end

    def each(&block)
      @enums.each do |_, value|
        block.call(value)
      end
    end

    def [](value)
      return nil if value.nil?

      @enums[value.to_sym] || @enums_by_value[value]
    end

    def values
      @enums_by_value.keys
    end

    def names
      @enums.keys
    end

    def to_s
      inspect
    end

    def inspect
      "#<EnumType enums=[#{names.map(&:to_s).join(', ')}]>"
    end

    def respond_to_missing?(method_name, *arguments, &block)
      method_name =~ /[A-Z]+/ && arguments.empty? && block.nil? || super
    end

    def method_missing(method_name, *arguments, &block)
      if method_name =~ /[A-Z]+/ && arguments.empty? && block.nil?
        raise UndefinedEnumError, "Undefined enumeration, #{method_name}"
      end

      super
    end
  end
end
