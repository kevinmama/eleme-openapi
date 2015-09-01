class InvalidArgumentType < Exception
  def initialize(name, type, value)
    @name = name
    super("argument '#{name}' values '#{value}' has invalid type, expect #{type} but was #{value.class}")
  end
end

class InvalidArgumentValue < Exception
  def initialize(arg_name)
    @arg_name = arg_name
    super("argument '#{@arg_name}' has invalid value")
  end
end

class MissingArgument < Exception
  def initialize(arg_name)
    @arg_name = arg_name
    super("missing argument #{@arg_name}")
  end
end
