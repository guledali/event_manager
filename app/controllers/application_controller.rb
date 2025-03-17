class ApplicationController < ActionController::Base
  include Authentication

  # Allow viewing events without authentication
  allow_unauthenticated_access only: [ :index, :show ], if: -> { self.class == EventsController }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
