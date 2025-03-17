import { Controller } from "@hotwired/stimulus";

// Controls Trix editor configuration
export default class extends Controller {
  connect() {
    // Remove the attachment button from the toolbar
    this.hideAttachmentButton();
  }

  hideAttachmentButton() {
    // Hide the attachment button when Trix is loaded
    addEventListener("trix-initialize", (event) => {
      const toolbar = event.target.toolbarElement;
      const attachmentButton = toolbar.querySelector(
        ".trix-button--icon-attach"
      );

      if (attachmentButton) {
        attachmentButton.style.display = "none";
      }
    });
  }
}
