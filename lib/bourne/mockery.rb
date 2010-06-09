require 'mocha/mockery'
require 'bourne/mock'
require 'bourne/invocation'

module Mocha
  class Mockery
    def invocation(mock, method_name, args)
      invocations << Invocation.new(mock, method_name, args)
    end

    def invocations
      @invocations ||= []
    end
  end
end
