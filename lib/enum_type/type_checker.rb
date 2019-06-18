require 'enum_type/errors'

module EnumType
  # Checks the type of value against kind. Supports classes and Dry Types.
  class TypeChecker
    def initialize(kind, value)
      @kind = kind
      @value = value
    end

    def check!
      return check_dry_type! if @kind.is_a?(Dry::Types::Type)

      raise_error! unless @value.is_a?(@kind)
    end

    private def check_dry_type!
      @kind[@value]
    rescue Dry::Types::ConstraintError
      raise_error!
    end

    private def raise_error!
      raise TypeError, "Invalid type, #{@value.inspect}, should be #{@kind.inspect}"
    end
  end
end
