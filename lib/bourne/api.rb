require 'mocha/api'
require 'bourne/mockery'

module Mocha # :nodoc:
  module API
    # Asserts that the given mock received the given method.
    #
    # Examples:
    #
    #   assert_received(mock, :to_s)
    #   assert_received(Radio, :new) {|expect| expect.with(1041) }
    #   assert_received(radio, :volume) {|expect| expect.with(11).twice }
    def assert_received(mock, expected_method_name)
      matcher = have_received(expected_method_name)
      yield(matcher) if block_given?
      assert matcher.matches?(mock), matcher.failure_message
    end

    class HaveReceived #:nodoc:
      def initialize(expected_method_name)
        @expected_method_name = expected_method_name
        @expectations = []
      end

      def method_missing(method, *args, &block)
        @expectations << [method, args, block]
        self
      end

      def matches?(mock)
        if mock.respond_to?(:mocha)
          @mock = mock.mocha
        else
          @mock = mock
        end

        @expectation = Expectation.new(@mock, @expected_method_name)
        @expectations.each do |method, args, block|
          @expectation.send(method, *args, &block)
        end
        @expectation.invocation_count = invocation_count
        @expectation.verified?
      end
      
      def failure_message
        @expectation.mocha_inspect
      end

      private

      def invocation_count
        matching_invocations.size
      end

      def matching_invocations
        invocations.select do |invocation|
          @expectation.match?(invocation.method_name, *invocation.arguments)
        end
      end

      def invocations
        Mockery.instance.invocations.select do |invocation|
          invocation.mock.equal?(@mock)
        end
      end
    end

    # :call-seq:
    #   should have_received(method).with(arguments).times(times)
    #
    # Ensures that the given mock received the given method.
    #
    # Examples:
    #
    #   mock.should have_received(:to_s)
    #   Radio.should have_received(:new).with(1041)
    #   radio.should have_received(:volume).with(11).twice
    def have_received(expected_method_name)
      HaveReceived.new(expected_method_name)
    end
  end
end
