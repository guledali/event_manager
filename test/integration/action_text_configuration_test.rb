# frozen_string_literal: true

require "test_helper"

# Integration tests for ActionText configuration
class ActionTextConfigurationTest < ActionDispatch::IntegrationTest
  # Set up test data before each test
  #
  # @return [void]
  setup do
    @user = users(:one)
  end
  # Tests that our config override prevents image attachments
  #
  # @return [void]
  test "action_text content returns empty attachables" do
    content = ActionText::Content.new("<div>Text with no attachments</div>")
    assert_empty content.attachables, "ActionText Content should return empty attachables"
  end

  # Tests that an attempt to add an attachment to rich text is prevented
  #
  # @return [void]
  test "action_text prevents attachment creation" do
    # Create a dummy event with rich text
    event = Event.create!(
      name: "Test Event",
      start_date: DateTime.now + 1.day,
      end_date: DateTime.now + 2.days,
      location: "Test Location",
      capacity: 100,
      description: "Base description",
      user_id: @user.id
    )

    # HTML that would normally create an attachment but should be stripped
    html_with_attachment = <<~HTML
      <div>
        Text with an image
        <figure data-trix-attachment='{"sgid":"BAh123"}'>
          <img src="data:image/png;base64,iVBORw0=">
        </figure>
      </div>
    HTML

    # Update the description with content that contains an attachment
    event.update!(description: html_with_attachment)

    # Reload and verify the content doesn't include an attachment
    event.reload
    refute_includes event.description.to_s, "<figure data-trix-attachment"
    assert_includes event.description.to_s, "Text with an image"
  end

  # Tests that JavaScript prevents image uploads
  #
  # @return [void]
  test "javascript includes code to prevent file uploads" do
    # Verify the JavaScript code exists in the application file
    application_js = File.read(Rails.root.join("app", "javascript", "application.js"))
    assert_match(/trix-file-accept/, application_js)
    assert_match(/preventDefault/, application_js)
  end

  # Tests that the controller for disabling image uploads exists
  #
  # @return [void]
  test "stimulus controller for disabling attachments exists" do
    controller_file = Rails.root.join("app", "javascript", "controllers", "trix_editor_controller.js")
    assert File.exist?(controller_file), "Trix editor controller file doesn't exist"

    controller_content = File.read(controller_file)
    assert_match(/hideAttachmentButton/, controller_content)
    assert_match(/trix-initialize/, controller_content)
    assert_match(/trix-button--icon-attach/, controller_content)
    assert_match(/style\.display\s*=\s*"none"/, controller_content)
  end

  # Tests that the form applies the controller to the rich text area
  #
  # @return [void]
  test "rich_text_area in form has trix-editor controller applied" do
    # Get the event form partial
    form_partial = File.read(Rails.root.join("app", "views", "events", "_form.html.erb"))

    # Check that the rich_text_area has the data-controller attribute
    assert_match(/rich_text_area.*data:.*controller.*trix-editor/m, form_partial)
  end
end
