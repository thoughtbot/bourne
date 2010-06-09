require 'mocha/mockery'
require 'bourne/mock'
require 'bourne/invocation'

module Mocha
  # Used internally by Bourne extensions to Mocha when recording invocations of
  # stubbed and mocked methods. You shouldn't need to interact with this module
  # through normal testing, but you can access the full list of invocations
  # directly if necessary.
  class Mockery
    def invocation(mock, method_name, args)
      invocations << Invocation.new(mock, method_name, args)
    end

    def invocations
      @invocations ||= []
    end
  end
end
