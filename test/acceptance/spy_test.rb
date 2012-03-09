require File.join(File.dirname(__FILE__), "acceptance_test_helper")
require 'bourne'
require 'matcher_helpers'

module SpyTestMethods

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_accept_wildcard_stub_call_without_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    assert_received(instance, :magic)
    assert_matcher_accepts have_received(:magic), instance
  end

  def test_should_accept_wildcard_stub_call_with_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(:argument)
    assert_received(instance, :magic)
    assert_matcher_accepts have_received(:magic), instance
  end

  def test_should_not_accept_wildcard_stub_without_call
    instance = new_instance
    instance.stubs(:magic)
    assert_fails { assert_received(instance, :magic) }
    assert_fails { assert_matcher_accepts have_received(:magic), instance }
  end

  def test_should_not_accept_call_without_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(1), instance }
  end

  def test_should_not_accept_call_with_different_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(2)
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(1), instance }
  end

  def test_should_accept_call_with_correct_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(1)
    assert_received(instance, :magic) {|expect| expect.with(1) }
    assert_matcher_accepts have_received(:magic).with(1), instance
  end

  def test_should_accept_call_with_wildcard_arguments
    instance = new_instance
    instance.stubs(:magic)
    instance.magic('hello')
    assert_received(instance, :magic) {|expect| expect.with(is_a(String)) }
    assert_matcher_accepts have_received(:magic).with(is_a(String)), instance
  end

  def test_should_reject_call_on_different_mock
    instance = new_instance
    other    = new_instance
    instance.stubs(:magic)
    other.stubs(:magic)
    other.magic('hello')
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(is_a(String)) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(is_a(String)), instance }
  end

  def test_should_accept_correct_number_of_calls
    instance = new_instance
    instance.stubs(:magic)
    2.times { instance.magic }
    assert_received(instance, :magic) {|expect| expect.twice }
    assert_matcher_accepts have_received(:magic).twice, instance
  end

  def test_should_not_allow_should_not
    begin
      have_received(:magic).does_not_match?(new_instance)
    rescue Mocha::API::InvalidHaveReceived => exception
      assert_match "should_not have_received(:magic) is invalid, please use should have_received(:magic).never", exception.message, "Test failed, but with the wrong message"
      return
    end
    flunk("Expected to fail")
  end

  def test_should_warn_for_unstubbed_methods_with_expectations
    new_instance.stubs(:unknown)

    assert_fails(/unstubbed, expected exactly once/) { assert_matcher_accepts have_received(:unknown), new_instance }
  end

  def test_should_reject_not_enough_calls
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    message = /expected exactly twice/
    assert_fails(message) { assert_received(instance, :magic) {|expect| expect.twice } }
    assert_fails(message) { assert_matcher_accepts have_received(:magic).twice, instance }
  end

  def test_should_reject_too_many_calls
    instance = new_instance
    instance.stubs(:magic)
    2.times { instance.magic }
    message = /expected exactly once/
    assert_fails(message) { assert_received(instance, :magic) {|expect| expect.once } }
    assert_fails(message) { assert_matcher_accepts have_received(:magic).once, instance }
  end

  def assert_fails(message=/not yet invoked/)
    begin
      yield
    rescue FailedAssertion => exception
      assert_match message, exception.message, "Test failed, but with the wrong message"
      return
    end
    flunk("Expected to fail")
  end

end

class PartialSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  include SpyTestMethods

  def new_instance
    Object.new
  end
end

class PureSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  include SpyTestMethods

  def new_instance
    stub
  end
end

class StubEverythingSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end
  def test_should_match_invocations_with_no_explicit_stubbing
    instance = stub_everything
    instance.surprise!
    assert_received(instance, :surprise!)
  end
end
