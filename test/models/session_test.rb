require "test_helper"

class SessionTest < ActiveSupport::TestCase
  # Tests the association with the User model
  test "should belong to a user" do
    session = Session.new
    assert_respond_to session, :user
    assert session.respond_to?(:user_id)
  end

  # Tests that a session can be created with valid attributes
  test "should create session with valid attributes" do
    user = users(:one)
    session = Session.new(user: user)
    assert session.save, "Could not save session with valid attributes"
  end

  # Tests that a session cannot be created without a user
  test "should not create session without user" do
    session = Session.new
    assert_not session.save, "Saved the session without a user"
  end
end
