# frozen_string_literal: true

# Event model for managing event details and functionality
#
# @attr [String] name The name/title of the event
# @attr [Text] description Detailed description of the event with rich text support
# @attr [DateTime] start_date When the event begins
# @attr [DateTime] end_date When the event ends
# @attr [String] location Where the event will be held
# @attr [Integer] capacity Maximum number of attendees allowed
# @attr [ActiveStorage::Attachment] image Optional event promotional image
class Event < ApplicationRecord
  include ImageValidatable

  has_one_attached :image
  has_rich_text :description
  belongs_to :user

  # Validations
  validates :name, :start_date, :end_date, :location, :description, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :end_date_after_start_date
  validate :acceptable_image, if: -> { image.attached? }

  # Returns the name of the user who organized this event
  #
  # @return [String] The organizer's name
  def organizer
    self.user.name
  end

  # Class Methods

  # Returns future events that haven't started yet
  #
  # @return [ActiveRecord::Relation<Event>] Collection of upcoming events sorted by start date
  def self.upcoming
    where("start_date > ?", Time.current).order(start_date: :asc)
  end

  # Returns past events that have already ended
  #
  # @return [ActiveRecord::Relation<Event>] Collection of past events sorted by start date in descending order
  def self.past
    where("end_date < ?", Time.current).order(start_date: :desc)
  end

  # Returns events currently in progress
  #
  # @return [ActiveRecord::Relation<Event>] Collection of ongoing events
  def self.ongoing
    where("start_date <= ? AND end_date >= ?", Time.current, Time.current)
  end

  private

  # Validates that end_date is after start_date
  #
  # @return [void]
  # @api private
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
