# frozen_string_literal: true

# Helper methods available to all views in the application
module ApplicationHelper
  # Checks if the current page is a main page (events index or root)
  #
  # @return [Boolean] true if on a main page, false otherwise
  def on_main_page?
    current_page?(events_path) || current_page?(root_path)
  end

  # Checks if a user is currently logged in
  #
  # @return [Boolean] true if a user is logged in, false otherwise
  def user_logged_in?
    Current.user.present?
  end
end
