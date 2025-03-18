require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Set up for CI environment with longer wait times
  if ENV["CI"] == "true"
    # Increase timeouts for CI environment
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |options|
      # Add Chrome options for better CI performance
      options.add_argument("--no-sandbox")
      options.add_argument("--disable-dev-shm-usage")
      options.add_argument("--disable-gpu")
      options.add_argument("--window-size=1400,1400")
      options.add_argument("--enable-javascript")
      # Enable more verbose logging
      options.add_argument("--verbose")
      options.add_argument("--log-level=0")
    end

    # Increase Capybara's default wait time for CI
    Capybara.default_max_wait_time = 15

    # Enable more debugging in CI
    Capybara.enable_aria_label = true
    Capybara.server = :puma, { Silent: false }
  else
    # Default setup for local development
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end

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

  # Take a screenshot and save page HTML on failures
  def after_teardown
    super
    if ENV["CI"] == "true" && failures.any?
      # Save current page HTML for debugging
      filename = File.basename(name).gsub(/\s+/, "_")
      save_path = Rails.root.join("tmp/debug/#{filename}.html")
      FileUtils.mkdir_p(File.dirname(save_path))
      File.write(save_path, page.html)

      # Print JS console logs if possible
      begin
        logs = page.driver.browser.logs.get(:browser)
        puts "JavaScript console logs:"
        logs.each { |log| puts log.message }
      rescue => e
        puts "Could not get browser logs: #{e.message}"
      end
    end
  end
end
