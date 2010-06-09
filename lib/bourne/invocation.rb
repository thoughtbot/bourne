module Mocha # :nodoc:
  # Used internally by Bourne extensions to Mocha. Represents a single
  # invocation of a stubbed or mocked method. The mock, method name, and
  # arguments are recorded and can be used to determine how a method was
  # invoked.
  class Invocation
    attr_reader :mock, :method_name, :arguments
    def initialize(mock, method_name, arguments)
      @mock        = mock
      @method_name = method_name
      @arguments   = arguments
    end
  end
end
