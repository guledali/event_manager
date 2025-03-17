# frozen_string_literal: true

# Disable direct uploads for ActionText
Rails.application.config.to_prepare do
  ActionText::Content.class_eval do
    def attachables
      # Return empty array to prevent any attachments from being processed
      []
    end
  end
end
