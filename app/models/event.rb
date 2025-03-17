class Event < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :acceptable_image, if: -> { image.attached? }
  validate :end_date_after_start_date

  scope :upcoming, -> { where("start_date > ?", Time.current).order(start_date: :asc) }
  scope :past, -> { where("end_date < ?", Time.current).order(start_date: :desc) }
  scope :ongoing, -> { where("start_date <= ? AND end_date >= ?", Time.current, Time.current) }

  private

  def acceptable_image
    return unless image.attached?

    unless image.blob.content_type.in?(%w[image/png image/jpeg image/jpg image/gif])
      errors.add(:image, "must be a valid image format (PNG, JPEG, JPG, GIF)")
    end

    unless image.blob.byte_size < 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
