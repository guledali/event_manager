# frozen_string_literal: true

# Controller responsible for managing events
#
# Handles CRUD operations for events and displays them to users
class EventsController < ApplicationController
  include Authentication

  before_action :set_event, only: %i[show edit update destroy]
  # We're using the Authentication concern which already has a require_authentication before_action
  # The ApplicationController has allow_unauthenticated_access for index and show
  before_action :check_authentication, except: %i[index show]
  before_action :ensure_session_resumed, only: [ :index, :show ]

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

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates an existing event with the provided parameters
  # Also handles image removal if specified
  #
  # @return [void]
  def update
    if params[:remove_image] == "1" && @event.image.attached?
      @event.image.purge
    end

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
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

  # Ensures that the session is resumed properly for public pages
  # where authentication is not required
  #
  # @return [void]
  def ensure_session_resumed
    resume_session
  end

  # Custom check for authentication that displays a specific message for event management
  #
  # @return [void]
  def check_authentication
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
    params.require(:event).permit(:name, :description, :start_date, :end_date, :location, :capacity, :image)
  end
end
