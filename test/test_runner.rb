require 'minitest'

require 'mocha/integration/mini_test'
require File.expand_path('../mini_test_result', __FILE__)

module TestRunner
  def run_as_test(test_result = nil, &block)
    test_class = Class.new(Minitest::Test) do
      define_method(:test_me, &block)
    end
    test = test_class.new(:test_me)

    runner = Minitest::Test.new
    test.run(runner)
    test_result = MinitestResult.new(runner, test)

    test_result
  end

  def assert_passed(test_result)
    flunk "Test failed unexpectedly with message: #{test_result.failures}" if test_result.failure_count > 0
    flunk "Test failed unexpectedly with message: #{test_result.errors}" if test_result.error_count > 0
  end

  def assert_failed(test_result)
    flunk "Test passed unexpectedly" if test_result.passed?
  end

end

