require 'mocha/mock'

module Mocha # :nodoc:
  # Extends #method_missing on Mocha::Mock to record Invocations.
  class Mock # :nodoc:
    alias_method :method_missing_without_invocation, :method_missing

    def method_missing(symbol, *arguments, &block)
      Mockery.instance.invocation(self, symbol, arguments)
      method_missing_without_invocation(symbol, *arguments, &block)
    end
  end
end
