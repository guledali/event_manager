require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Sign in a user for system tests
  #
  # @param [User] user The user to sign in
  # @return [void]
  def sign_in_as(user)
    # Create a session for the user
    session = Session.create!(user: user)
    # Set the session cookie
    page.driver.browser.execute_cdp(
      "Network.setCookie",
      domain: "127.0.0.1",
      name: "session_id",
      value: session.id,
      path: "/"
    )
  end
end
