require 'mocha/mock'
require 'bourne/expectation'
require 'mocha/expectation_error_factory'

module Mocha # :nodoc:
  # Overwrites #method_missing on Mocha::Mock
  # - pass arguments to .invoke() calls to create Invocation
  # - keep lowest else branch (bourne code)
  # - update from https://github.com/freerange/mocha/blob/master/lib/mocha/mock.rb#L195
  # - update test/unit/mock_test.rb
  class Mock # :nodoc:
    def method_missing(symbol, *arguments, &block)
      if @responder and not @responder.respond_to?(symbol)
        raise NoMethodError, "undefined method `#{symbol}' for #{self.mocha_inspect} which responds like #{@responder.mocha_inspect}"
      end
      if matching_expectation_allowing_invocation = @expectations.match_allowing_invocation(symbol, *arguments)
        matching_expectation_allowing_invocation.invoke(arguments, &block)
      else
        if (matching_expectation = @expectations.match(symbol, *arguments)) || (!matching_expectation && !@everything_stubbed)
          matching_expectation.invoke(arguments, &block) if matching_expectation
          message = UnexpectedInvocation.new(self, symbol, *arguments).to_s
          message << @mockery.mocha_inspect
          raise ExpectationErrorFactory.build(message, caller)
        else
          target = if self.respond_to? :mocha
            self.mocha
          else
            mocha
          end
          Mockery.instance.invocation(target, symbol, arguments)
          nil
        end
      end
    end
  end
end
