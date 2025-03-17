require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @test_image = fixture_file_upload("test_image.jpg", "image/jpeg")
  end

  test "should not save event without name" do
    event = Event.new(
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100
    )
    assert_not event.save, "Saved the event without a name"
  end

  test "should not save event without description" do
    event = Event.new(
      name: "Test Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100
    )
    assert_not event.save, "Saved the event without a description"
  end

  test "should not save event without start date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100
    )
    assert_not event.save, "Saved the event without a start date"
  end

  test "should not save event without end date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      location: "Test location",
      capacity: 100
    )
    assert_not event.save, "Saved the event without an end date"
  end

  test "should not save event without location" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      capacity: 100
    )
    assert_not event.save, "Saved the event without a location"
  end

  test "should not save event without capacity" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location"
    )
    assert_not event.save, "Saved the event without a capacity"
  end

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

  test "should not save event with negative capacity" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: -10
    )
    assert_not event.save, "Saved the event with a negative capacity"
  end

  test "should not save event with end date before start date" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 2.days,
      end_date: DateTime.now + 1.day,
      location: "Test location",
      capacity: 100
    )
    assert_not event.save, "Saved the event with end date before start date"
    assert_includes event.errors[:end_date], "must be after the start date"
  end

  test "should save valid event" do
    event = Event.new(
      name: "Test Event",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100
    )
    assert event.save, "Could not save a valid event"
  end

  test "should save valid event with image" do
    event = Event.new(
      name: "Test Event with Image",
      description: "Test description",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test location",
      capacity: 100
    )
    event.image.attach(@test_image)
    assert event.save, "Could not save a valid event with image"
    assert event.image.attached?
  end

  test "upcoming scope returns future events" do
    upcoming_events = Event.upcoming
    assert_includes upcoming_events, events(:conference)
    assert_includes upcoming_events, events(:workshop)
    assert_not_includes upcoming_events, events(:past_event)
    assert_not_includes upcoming_events, events(:ongoing_event)
  end

  test "past scope returns past events" do
    past_events = Event.past
    assert_includes past_events, events(:past_event)
    assert_not_includes past_events, events(:conference)
    assert_not_includes past_events, events(:workshop)
    assert_not_includes past_events, events(:ongoing_event)
  end

  test "ongoing scope returns current events" do
    ongoing_events = Event.ongoing
    assert_includes ongoing_events, events(:ongoing_event)
    assert_not_includes ongoing_events, events(:conference)
    assert_not_includes ongoing_events, events(:workshop)
    assert_not_includes ongoing_events, events(:past_event)
  end
end
