require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Tests that a user with valid attributes can be created
  test "should create user with valid attributes" do
    user = User.new(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.save, "Could not save user with valid attributes"
  end

  # Tests that email normalization works correctly
  test "should normalize email address" do
    user = User.create(
      email_address: "  Test@EXAMPLE.com  ",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_equal "test@example.com", user.email_address
  end

  # Tests that password confirmation is required
  test "should not save user with mismatched password confirmation" do
    user = User.new(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "different"
    )
    assert_not user.save, "Saved user with mismatched password confirmation"
  end

  # Tests that sessions are destroyed when a user is destroyed
  test "should destroy associated sessions when user is destroyed" do
    user = users(:one)
    assert_difference("Session.count", -user.sessions.count) do
      user.destroy
    end
  end
end
