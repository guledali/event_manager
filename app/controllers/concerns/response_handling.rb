# frozen_string_literal: true

# Provides standardized response handling for controller actions
#
# This concern encapsulates common response patterns for CRUD operations
module ResponseHandling
  extend ActiveSupport::Concern

  # Handles standard response for create and update actions
  #
  # @param success [Boolean] Whether the operation was successful
  # @param resource [ActiveRecord::Base] The resource being created or updated
  # @param options [Hash] Additional options for customizing the response
  # @option options [String] :resource_name The name of the resource type (e.g., "Event")
  # @option options [Symbol] :redirect_path Method to call for redirect path
  # @return [void]
  def respond_with_result(success, resource, options = {})
    resource_name = options[:resource_name] || resource.class.name
    redirect_path = options[:redirect_path] || "#{resource.class.name.underscore}_url"

    respond_to do |format|
      if success
        action = resource.previously_new_record? ? "created" : "updated"
        flash[:notice] = "#{resource_name} '#{resource.name}' was successfully #{action}."

        handle_success_response(format, resource, action, redirect_path)
      else
        action = action_name == "create" ? "create" : "update"
        flash.now[:alert] = "Failed to #{action} #{resource_name.downcase}: #{resource.errors.full_messages.join(', ')}"

        handle_error_response(format, resource)
      end
    end
  end

  private

  # Handles format responses for successful operations
  #
  # @param format [ActionController::MimeResponds::Collector] The format responder
  # @param resource [ActiveRecord::Base] The resource being created or updated
  # @param action [String] The action that was performed ("created" or "updated")
  # @param redirect_path [String] The path to redirect to
  # @return [void]
  def handle_success_response(format, resource, action, redirect_path)
    format.html { redirect_to send(redirect_path, resource) }
    format.json do
      render :show,
             status: resource.previously_new_record? ? :created : :ok,
             location: resource
    end
  end

  # Handles format responses for failed operations
  #
  # @param format [ActionController::MimeResponds::Collector] The format responder
  # @param resource [ActiveRecord::Base] The resource being created or updated
  # @return [void]
  def handle_error_response(format, resource)
    format.html do
      render resource.persisted? ? :edit : :new,
             status: :unprocessable_entity
    end
    format.json { render json: resource.errors, status: :unprocessable_entity }
  end
end
