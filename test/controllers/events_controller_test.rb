require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:conference)
    @invalid_event = events(:invalid_dates)
    @test_image = fixture_file_upload("test_image.jpg", "image/jpeg")
  end

  test "should get index" do
    get events_url
    assert_response :success
    assert_select "h1", "Events"
    assert_select ".card", minimum: 3
  end

  test "should get new" do
    get new_event_url
    assert_response :success
    assert_select "h1", "Create New Event"
    assert_select "form"
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: {
        name: "New Test Event",
        description: "Test description",
        start_date: DateTime.now + 1.day,
        end_date: DateTime.now + 2.days,
        location: "Test Location",
        capacity: 100,
        image: @test_image
      } }
    end

    assert_redirected_to event_url(Event.last)
    follow_redirect!
    assert_select "h1", "New Test Event"
    assert Event.last.image.attached?
  end

  test "should not create event with invalid data" do
    assert_no_difference("Event.count") do
      post events_url, params: { event: {
        name: "",
        description: "Test description",
        start_date: DateTime.now + 1.day,
        end_date: DateTime.now + 2.days,
        location: "Test Location",
        capacity: 100
      } }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
    assert_select "h1", @event.name
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
    assert_select "h1", "Edit Event"
    assert_select "form"
  end

  test "should update event" do
    patch event_url(@event), params: { event: {
      name: "Updated Event Name",
      description: @event.description,
      start_date: @event.start_date,
      end_date: @event.end_date,
      location: @event.location,
      capacity: @event.capacity
    } }

    assert_redirected_to event_url(@event)
    follow_redirect!
    assert_select "h1", "Updated Event Name"
  end

  test "should update event with image" do
    patch event_url(@event), params: {
      event: {
        name: @event.name,
        description: @event.description,
        start_date: @event.start_date,
        end_date: @event.end_date,
        location: @event.location,
        capacity: @event.capacity,
        image: @test_image
      }
    }

    assert_redirected_to event_url(@event)
    assert @event.reload.image.attached?
  end

  test "should not update event with invalid data" do
    patch event_url(@event), params: { event: {
      name: "",
      description: @event.description,
      start_date: @event.start_date,
      end_date: @event.end_date,
      location: @event.location,
      capacity: @event.capacity
    } }

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
