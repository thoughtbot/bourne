require 'mocha/expectation'

module Mocha # :nodoc:
  class Expectation
    attr_accessor :invocation_count

    def invoke_with_args(args, &block)
      Mockery.instance.invocation(@mock, method_name, args)
      invoke_without_args(&block)
    end

    alias_method :invoke_without_args, :invoke
    alias_method :invoke, :invoke_with_args

    private

    def method_name
      @method_matcher.expected_method_name
    end
  end
end
