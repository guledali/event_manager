# frozen_string_literal: true

# Controller responsible for managing events
#
# Handles CRUD operations for events and displays them to users
class EventsController < ApplicationController
  include Authentication
  include ResponseHandling

  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_for_management, except: %i[index show]
  before_action :resume_session, only: %i[index show]

  # Displays list of events grouped by their status
  #
  # @return [void]
  def index
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    @past_events = Event.past.limit(5)
    @events = Event.all.order(start_date: :asc)
  end

  # Displays a specific event with detailed information
  #
  # @return [void]
  def show
  end

  # Displays form for creating a new event
  #
  # @return [void]
  def new
    @event = Event.new
  end

  # Displays form for editing an existing event
  #
  # @return [void]
  def edit
  end

  # Creates a new event with the provided parameters
  #
  # @return [void]
  def create
    @event = Event.new(event_params)

    respond_with_result(@event.save, @event, resource_name: "Event")
  end

  # Updates an existing event with the provided parameters
  # Also handles image removal if specified
  #
  # @return [void]
  def update
    handle_image_removal if params[:remove_image] == "1"
    respond_with_result(@event.update(event_params), @event, resource_name: "Event")
  end

  # Permanently removes an event from the database
  #
  # @return [void]
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Handles image removal when requested
  #
  # @return [void]
  def handle_image_removal
    @event.image.purge if @event.image.attached?
  end

  # Custom check for authentication that displays a specific message for event management
  #
  # @return [void]
  def authenticate_for_management
    unless authenticated?
      flash[:alert] = "You need to be logged in to manage events."
      redirect_to request.referer || events_path
      false
    end
  end

  # Finds the requested event by ID
  #
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] If event with provided ID doesn't exist
  def set_event
    @event = Event.find(params[:id])
  end

  # Whitelists permitted parameters for event creation and updates
  #
  # @return [ActionController::Parameters] Sanitized parameters for event
  def event_params
    params.expect(event: [ :name, :description, :start_date, :end_date, :location, :capacity, :image, :user_id ])
  end
end
