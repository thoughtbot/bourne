unless defined?(STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS)
  STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS = Object.public_instance_methods
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit', 'parameter_matchers'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'acceptance'))

if ENV['MOCHA_OPTIONS'] == 'use_test_unit_gem'
  require 'rubygems'
  gem 'test-unit'
end

require 'test/unit'
require 'mocha/setup'

if defined?(MiniTest)
  FailedAssertion = MiniTest::Assertion
else
  FailedAssertion = Test::Unit::AssertionFailedError
end
