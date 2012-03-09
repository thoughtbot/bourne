Bourne [![Build Status](https://secure.travis-ci.org/thoughtbot/bourne.png)](http://travis-ci.org/thoughtbot/bourne)
======

Bourne extends mocha to allow detailed tracking and querying of stub and mock
invocations. It allows test spies using the have_received rspec matcher and
assert_received for Test::Unit. Bourne was extracted from jferris-mocha, a fork
of mocha that adds test spies.

Test Spies
----------

Test spies are a form of test double that preserves the normal four-phase unit
test order and allows separation of stubbing and verification.

Using a test spy is like using a mocked expectation except that there are two steps:

1. Stub out a method for which you want to verify invocations
2. Use an assertion or matcher to verify that the stub was invoked correctly

Examples
--------

RSpec:

    mock.should have_received(:to_s)
    Radio.should have_received(:new).with(1041)
    radio.should have_received(:volume).with(11).twice
    radio.should have_received(:off).never

You also want to configure RSpec to use mocha for mocking:

    RSpec.configure do |config|
      config.mock_with :mocha
    end

Test::Unit:

    assert_received(mock, :to_s)
    assert_received(Radio, :new) {|expect| expect.with(1041) }
    assert_received(radio, :volume) {|expect| expect.with(11).twice }
    assert_received(radio, :off) {|expect| expect.never }

See Mocha::API for more information.

Install
-------

    gem install bourne

More Information
----------------

* [RDoc](http://rdoc.info/projects/thoughtbot/bourne)
* [Issues](http://github.com/thoughtbot/bourne/issues)
* [Mocha mailing list](http://groups.google.com/group/mocha-developer)

Credits
-------

Bourne was written by Joe Ferris. Mocha was written by James Mead. Several of
the test examples and helpers used in the Bourne test suite were copied
directly from Mocha.

Thanks to thoughtbot for inspiration, ideas, and funding. Thanks to James for
writing mocha.

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Thank you to all [the contributors](https://github.com/thoughtbot/bourne/contributors)!

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Bourne is Copyright © 2010-2011 Joe Ferris and thoughtbot. It is free software, and may be redistributed under the terms specified in the LICENSE file.
