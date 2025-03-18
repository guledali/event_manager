# frozen_string_literal: true

# Helper module for event-related view logic
module EventsHelper
  # Returns a formatted date range for an event
  #
  # @param event [Event] The event to format dates for
  # @return [String] Formatted date range
  def event_date_range(event)
    if event.start_date.to_date == event.end_date.to_date
      "#{event.start_date.strftime('%B %d, %Y')} from #{event.start_date.strftime('%I:%M %p')} to #{event.end_date.strftime('%I:%M %p')}"
    else
      "#{event.start_date.strftime('%B %d, %Y at %I:%M %p')} to #{event.end_date.strftime('%B %d, %Y at %I:%M %p')}"
    end
  end

  # Returns appropriate CSS class based on event status
  #
  # @param event [Event] The event to check
  # @return [String] CSS class name
  def event_status_class(event)
    if Time.current < event.start_date
      "upcoming"
    elsif Time.current > event.end_date
      "past"
    else
      "ongoing"
    end
  end

  # Returns the status text for an event
  #
  # @param event [Event] The event to get status for
  # @return [String] Status text
  def event_status(event)
    if Time.current < event.start_date
      "Upcoming"
    elsif Time.current > event.end_date
      "Past"
    else
      "Ongoing"
    end
  end
end
