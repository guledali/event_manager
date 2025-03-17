require "test_helper"

class CurrentTest < ActiveSupport::TestCase
  # Tests that Current has a session attribute
  test "should have session attribute" do
    assert_respond_to Current, :session
    assert_respond_to Current, :session=
  end

  # Tests that Current delegates user to session
  test "should delegate user to session" do
    user = users(:one)
    session = sessions(:one)

    Current.session = session
    assert_equal user, Current.user
  end

  # Tests that Current user is nil when session is nil
  test "should return nil for user when session is nil" do
    Current.session = nil
    assert_nil Current.user
  end

  # Tests that Current is reset after each request
  test "should reset after request" do
    Current.session = sessions(:one)
    assert_not_nil Current.session

    Current.reset
    assert_nil Current.session
  end
end
