module EnumType
  class InvalidDefinitionError < RuntimeError; end
  class UndefinedEnumError < RuntimeError; end
  class TypeError < RuntimeError; end
  class DuplicateDefinitionError < RuntimeError; end
end
