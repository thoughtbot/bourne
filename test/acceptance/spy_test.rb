require 'spec_helper'
require 'bourne'
require 'matcher_helpers'

shared_context_for "Spy Test" do
  before do
    setup_acceptance_test
  end

  after do
    teardown_acceptance_test
  end
end

shared_examples_for "Spy Test" do
  it 'should accept wildcard stub call without arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    assert_received(instance, :magic)
    assert_matcher_accepts have_received(:magic), instance
  end

  it 'should accept wildcard stub call with arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(:argument)
    assert_received(instance, :magic)
    assert_matcher_accepts have_received(:magic), instance
  end

  it 'should not accept wildcard stub without call' do
    instance = new_instance
    instance.stubs(:magic)
    assert_fails { assert_received(instance, :magic) }
    assert_fails { assert_matcher_accepts have_received(:magic), instance }
  end

  it 'should not accept call without arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(1), instance }
  end

  it 'should not accept call with different arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(2)
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(1) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(1), instance }
  end

  it 'should accept call with correct arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic(1)
    assert_received(instance, :magic) {|expect| expect.with(1) }
    assert_matcher_accepts have_received(:magic).with(1), instance
  end

  it 'should_accept_call_with_wildcard_arguments' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic('hello')
    assert_received(instance, :magic) {|expect| expect.with(is_a(String)) }
    assert_matcher_accepts have_received(:magic).with(is_a(String)), instance
  end

  it 'should reject call on different mock' do
    instance = new_instance
    other    = new_instance
    instance.stubs(:magic)
    other.stubs(:magic)
    other.magic('hello')
    assert_fails { assert_received(instance, :magic) {|expect| expect.with(is_a(String)) } }
    assert_fails { assert_matcher_accepts have_received(:magic).with(is_a(String)), instance }
  end

  it 'should accept correct number of calls' do
    instance = new_instance
    instance.stubs(:magic)
    2.times { instance.magic }
    assert_received(instance, :magic) {|expect| expect.twice }
    assert_matcher_accepts have_received(:magic).twice, instance
  end

  it 'should not allow should not' do
    begin
      have_received(:magic).does_not_match?(new_instance)
    rescue Mocha::API::InvalidHaveReceived => exception
      assert_match "should_not have_received(:magic) is invalid, please use should have_received(:magic).never", exception.message, "Test failed, but with the wrong message"
      return
    end
    flunk("Expected to fail")
  end

  it 'should warn for unstubbed methods with expectations' do
    new_instance.stubs(:unknown)

    assert_fails(/unstubbed, expected exactly once/) { assert_matcher_accepts have_received(:unknown), new_instance }
  end

  it 'should reject not enough calls' do
    instance = new_instance
    instance.stubs(:magic)
    instance.magic
    message = /expected exactly twice/
    assert_fails(message) { assert_received(instance, :magic) {|expect| expect.twice } }
    assert_fails(message) { assert_matcher_accepts have_received(:magic).twice, instance }
  end

  it 'should reject too many calls' do
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
  include_context "Spy Test"
  it_behaves_like "Spy Test"

  def new_instance
    Object.new
  end
end

class PureSpyTest < Test::Unit::TestCase
  include AcceptanceTest
  include_context "Spy Test"
  it_behaves_like "Spy Test"

  def new_instance
    stub
  end
end

describe 'stub_everything spy' do
  include AcceptanceTest

  before do
    setup_acceptance_test
  end

  after do
    teardown_acceptance_test
  end

  it 'should match invocations with no explicit stubbing' do
    instance = stub_everything
    instance.surprise!
    assert_received(instance, :surprise!)
  end
end
