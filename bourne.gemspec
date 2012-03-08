# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bourne/version"

Gem::Specification.new do |s|
  s.name        = 'bourne'
  s.version     = Bourne::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joe Ferris"]
  s.email       = 'jferris@thoughtbot.com'
  s.homepage    = 'http://github.com/thoughtbot/bourne'
  s.summary     = 'Adds test spies to mocha.'
  s.description = %q{Extends mocha to allow detailed tracking and querying of
    stub and mock invocations. Allows test spies using the have_received rspec
    matcher and assert_received for Test::Unit. Extracted from the
    jferris-mocha fork.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('mocha', '= 0.10.5')

  s.add_development_dependency('rake')
end
