# frozen_string_literal: true

require "test_helper"

# Test suite for the Event model
#
# Tests validations, scopes, and image attachment functionality
class EventTest < ActiveSupport::TestCase
  # Set up test data before each test
  #
  # @return [void]
  setup do
    @test_image = fixture_file_upload("test_image.jpg", "image/jpeg")
    @user = users(:one)
  end

  # Tests that events require a name to be valid
  #
  # @return [void]
  test "should not save event without name" do
    event = Event.new(
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event without a name"
  end

  # Tests that events require a description to be valid
  #
  # @return [void]
  test "should not save event without description" do
    event = Event.new(
      name: "Test Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    # Since ActionText descriptions are validated differently, we need to check for error
    event.save
    assert_includes event.errors[:description], "can't be blank"
  end

  # Tests that events require a start date to be valid
  #
  # @return [void]
  test "should not save event without start date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event without a start date"
  end

  # Tests that events require an end date to be valid
  #
  # @return [void]
  test "should not save event without end date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event without an end date"
  end

  # Tests that events require a location to be valid
  #
  # @return [void]
  test "should not save event without location" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      capacity: 100,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event without a location"
  end

  # Tests that events require a capacity to be valid
  #
  # @return [void]
  test "should not save event without capacity" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      user_id: @user.id
    )
    assert_not event.save, "Saved the event without a capacity"
  end

  # Tests that capacity must be an integer value
  #
  # @return [void]
  test "should not save event with non-integer capacity" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 10.5
    )
    assert_not event.save, "Saved the event with a non-integer capacity"
  end

  # Tests that capacity must be a positive number
  #
  # @return [void]
  test "should not save event with negative capacity" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: -10,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event with a negative capacity"
  end

  # Tests that end date must be after start date
  #
  # @return [void]
  test "should not save event with end date before start date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 2.days,
      end_date: DateTime.now + 1.day,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    assert_not event.save, "Saved the event with end date before start date"
    assert_includes event.errors[:end_date], "must be after the start date"
  end

  # Tests that a valid event can be saved
  #
  # @return [void]
  test "should save valid event" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    assert event.save, "Could not save a valid event"
  end

  # Tests that a valid event with an image can be saved
  #
  # @return [void]
  test "should save valid event with image" do
    event = Event.new(
      name: "Test Event with Image",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )
    event.image.attach(@test_image)
    assert event.save, "Could not save a valid event with image"
    assert event.image.attached?
  end

  # Tests that the upcoming scope returns future events
  #
  # @return [void]
  test "upcoming scope returns future events" do
    upcoming_events = Event.upcoming
    assert_includes upcoming_events, events(:conference)
    assert_includes upcoming_events, events(:workshop)
    assert_not_includes upcoming_events, events(:past_event)
    assert_not_includes upcoming_events, events(:ongoing_event)
  end

  # Tests that the past scope returns past events
  #
  # @return [void]
  test "past scope returns past events" do
    past_events = Event.past
    assert_includes past_events, events(:past_event)
    assert_not_includes past_events, events(:conference)
    assert_not_includes past_events, events(:workshop)
    assert_not_includes past_events, events(:ongoing_event)
  end

  # Tests that the ongoing scope returns current events
  #
  # @return [void]
  test "ongoing scope returns current events" do
    ongoing_events = Event.ongoing
    assert_includes ongoing_events, events(:ongoing_event)
    assert_not_includes ongoing_events, events(:conference)
    assert_not_includes ongoing_events, events(:workshop)
    assert_not_includes ongoing_events, events(:past_event)
  end

  # Tests that events can save rich text content in description
  #
  # @return [void]
  test "should save event with rich text description" do
    event = Event.new(
      name: "Rich Text Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )

    # HTML content with formatting
    html_content = "<div>This is a <strong>formatted</strong> description with <em>styling</em>.</div>"
    event.description = ActionText::Content.new(html_content)

    assert event.save, "Could not save event with rich text description"
    assert_includes event.description.to_s, "<strong>formatted</strong>"
    assert_includes event.description.to_s, "<em>styling</em>"
  end

  # Tests that rich text description preserves formatting
  #
  # @return [void]
  test "should preserve formatting in rich text description" do
    event = Event.new(
      name: "Formatted Content Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      user_id: @user.id
    )

    html_content = '<div>This has a <a href="https://example.com">link</a> and <strong>bold text</strong>.</div>'
    event.description = ActionText::Content.new(html_content)

    assert event.save, "Could not save event with formatted rich text"
    assert_includes event.description.to_s, '<a href="https://example.com">link</a>'
    assert_includes event.description.to_s, "<strong>bold text</strong>"
  end

  # Tests that ActionText description doesn't contain attachments
  #
  # @return [void]
  test "action text description should not contain attachments" do
    event = Event.create!(
      name: "No Attachments Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100,
      description: ActionText::Content.new("Simple text description"),
      user_id: @user.id
    )

    # Attempt to add HTML with an attachment figure
    html_with_attachment = <<~HTML
      <div>
        Text with an image
        <figure data-trix-attachment='{"sgid":"BAh123"}'>
          <img src="data:image/png;base64,iVBORw0=">
        </figure>
      </div>
    HTML

    event.update!(description: html_with_attachment)
    event.reload

    # Verify the content doesn't include an attachment
    refute_includes event.description.to_s, "<figure data-trix-attachment"
    assert_includes event.description.to_s, "Text with an image"
  end
end
