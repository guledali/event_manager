# frozen_string_literal: true

# Module for validating image attachments in ActiveStorage
#
# This concern provides methods for validating attached images
# for size and format requirements.
module ImageValidatable
  extend ActiveSupport::Concern

  # Constants for image validation
  VALID_CONTENT_TYPES = %w[image/png image/jpeg image/jpg image/gif].freeze
  MAX_IMAGE_SIZE = 5.megabytes

  private

  # Validates that attached images meet size and format requirements
  #
  # @return [void]
  # @api private
  def acceptable_image
    return unless image.attached?

    validate_image_content_type
    validate_image_size
  end

  # Validates image content type is among accepted formats
  #
  # @return [void]
  # @api private
  def validate_image_content_type
    unless image.blob.content_type.in?(VALID_CONTENT_TYPES)
      errors.add(:image, "must be a valid image format (PNG, JPEG, JPG, GIF)")
    end
  end

  # Validates image size is below maximum allowed size
  #
  # @return [void]
  # @api private
  def validate_image_size
    unless image.blob.byte_size < MAX_IMAGE_SIZE
      errors.add(:image, "should be less than 5MB")
    end
  end
end
