require 'mocha/mock'
require 'bourne/expectation'

module Mocha # :nodoc:
  # Overwrites #method_missing on Mocha::Mock so pass arguments to
  # Mocha::Expectation#invoke so that an Invocation can be created.
  class Mock # :nodoc:
    def method_missing(symbol, *arguments, &block)
      if @responder and not @responder.respond_to?(symbol)
        raise NoMethodError, "undefined method `#{symbol}' for #{self.mocha_inspect} which responds like #{@responder.mocha_inspect}"
      end
      if matching_expectation_allowing_invocation = @expectations.match_allowing_invocation(symbol, *arguments)
        matching_expectation_allowing_invocation.invoke(arguments, &block)
      else
        if (matching_expectation = @expectations.match(symbol, *arguments)) || (!matching_expectation && !@everything_stubbed)
          message = UnexpectedInvocation.new(self, symbol, *arguments).to_s
          message << Mockery.instance.mocha_inspect
          raise ExpectationError.new(message, caller)
        end
      end
    end
  end
end
