// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import "trix";
import "@rails/actiontext";

// Prevent file attachments in Trix editor
addEventListener("trix-file-accept", (event) => {
  event.preventDefault();
});
