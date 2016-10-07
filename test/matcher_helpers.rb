class Minitest::Test
  def assert_matcher_accepts(matcher, instance)
    assert matcher.matches?(instance), matcher.failure_message
  end
end
