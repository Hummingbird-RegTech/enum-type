require 'enum_type/errors'
require 'enum_type/enum_class'

module EnumType
  # An Enum representation. Initialized by EnumType.create.
  class Enum
    # Context object for evaluating the Enum block.
    # Uses method_missing to collect enum definitions
    class Context
      attr_reader :enums

      def initialize(enum_klass)
        @enum_klass = enum_klass
        @enums = {}
      end

      def respond_to_missing?(method_name, *arguments, &block)
        method_name =~ /[A-Z]+/ && block.nil? || super
      end

      def method_missing(method_name, *arguments, &block)
        if method_name =~ /[A-Z]+/
          unless block.nil?
            raise InvalidDefinitionError, 'Cannot provide a block to an enum'
          end
          @enums[method_name] = @enum_klass.new(*arguments)
        else
          super
        end
      end
    end

    include Enumerable

    def initialize(attributes, &block)
      enum_class = EnumClass.create(attributes)
      context = Context.new(enum_class)
      context.instance_eval(&block)
      raise InvalidDefinitionError, 'Must define an enumeration' if context.enums.empty?
      @enums = context.enums
      context.enums.each do |name, value|
        define_singleton_method(name) do
          value
        end
      end
    end

    def each
      @enums.each do |_, value|
        yield(value)
      end
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
