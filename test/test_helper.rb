# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  # Base class for all test cases in the application
  #
  # Provides common functionality and helpers for tests
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order
    fixtures :all

    # Include helper methods for file uploads
    include ActionDispatch::TestProcess

    # Returns the path to fixture files for testing
    #
    # @return [Pathname] Path to fixture files directory
    def file_fixture_path
      Rails.root.join("test", "fixtures", "files")
    end
  end
end

# Helper methods for authentication in integration tests
module AuthenticationHelpers
  # Sign in a user for testing
  #
  # @param [User] user The user to sign in
  # @return [Session] The created session
  def sign_in_as(user)
    session = Session.create!(user: user)
    cookies[:session_id] = session.id
    session
  end
end

# Include authentication helpers in integration tests
class ActionDispatch::IntegrationTest
  include AuthenticationHelpers
end
