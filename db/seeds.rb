# frozen_string_literal: true

# Seed file to generate initial data for the application
# The data can be loaded with the bin/rails db:seed command or created alongside the database with db:setup.
#
# @example Running seeds
#   rails db:seed

require 'open-uri'
require 'fileutils'

# Create a default admin user
puts "Creating default admin user..."
if User.find_by(email_address: "guled@hey.com").nil?
  User.create!(email_address: "guled@hey.com", password: "root")
  puts "✅ Default admin user created"
else
  puts "Default admin user already exists"
end

# Clear existing events to avoid duplicates when re-seeding
Event.destroy_all

puts "Creating events..."

# Helper method to download stock images if they don't exist
#
# @param image_url [String] URL of the image to download
# @param filename [String] Name to save the file as
# @return [String] Path to the downloaded image
def download_stock_image(image_url, filename)
  # Create the destination directory if it doesn't exist
  destination_dir = Rails.root.join("app/assets/images/events")
  FileUtils.mkdir_p(destination_dir) unless Dir.exist?(destination_dir)

  file_path = destination_dir.join(filename)

  # Only download if file doesn't exist
  unless File.exist?(file_path)
    begin
      puts "Downloading image from #{image_url}..."
      downloaded_image = URI.open(image_url)
      IO.copy_stream(downloaded_image, file_path)
      puts "Image downloaded successfully!"
    rescue StandardError => e
      puts "Error downloading image: #{e.message}"
      return nil
    end
  else
    puts "Using existing image: #{filename}"
  end

  file_path
end

# Stock images for each event type from free sources
stock_images = {
  tech_conference: {
    url: "https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg",
    filename: "tech_conference.jpg"
  },
  music_festival: {
    url: "https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg",
    filename: "music_festival.jpg"
  },
  coding_workshop: {
    url: "https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg",
    filename: "coding_workshop.jpg"
  },
  charity_gala: {
    url: "https://images.pexels.com/photos/1114425/pexels-photo-1114425.jpeg",
    filename: "charity_gala.jpg"
  },
  business_networking: {
    url: "https://images.pexels.com/photos/1170412/pexels-photo-1170412.jpeg",
    filename: "business_networking.jpg"
  }
}

# Download all stock images
stock_images.each do |key, image_data|
  download_stock_image(image_data[:url], image_data[:filename])
end

# Event data to seed the database
# Each hash represents one event with all required attributes
events_data = [
  {
    name: "Tech Conference 2025",
    description: %(
      <div>
        <h3>Annual Technology Conference</h3>
        <p>Join us for three days of inspiring <strong>keynotes</strong>, hands-on workshops, and networking opportunities with industry leaders.</p>

        <h4>Event Highlights:</h4>
        <ul>
          <li>Keynote speeches from tech industry leaders</li>
          <li>Hands-on workshops on the latest technologies</li>
          <li>Networking sessions with peers and mentors</li>
          <li>Product showcases and demonstrations</li>
          <li>Career opportunities and recruitment</li>
        </ul>

        <p>This event will feature the latest innovations in <em>AI and machine learning</em>. Don't miss this chance to stay ahead in the rapidly evolving tech landscape!</p>
      </div>
    ),
    start_date: DateTime.now + 30.days,
    end_date: DateTime.now + 32.days,
    location: "San Francisco Convention Center",
    capacity: 500,
    image_filename: stock_images[:tech_conference][:filename]
  },
  {
    name: "Music Festival",
    description: %(
      <div>
        <h3>Three-Day Outdoor Music Experience</h3>
        <p>Experience <strong>diverse musical genres</strong>, food vendors, art installations, and create unforgettable memories with friends.</p>

        <h4>Festival Features:</h4>
        <ul>
          <li>Multiple stages with international artists</li>
          <li>Diverse food court with local and international cuisine</li>
          <li>Art installations and interactive experiences</li>
          <li>Camping options available on-site</li>
          <li>Family-friendly areas and activities</li>
        </ul>

        <p>Our lineup includes top artists from around the world performing across <em>five uniquely themed stages</em>. Come for the music, stay for the experience!</p>
      </div>
    ),
    start_date: DateTime.now + 60.days,
    end_date: DateTime.now + 63.days,
    location: "Central Park",
    capacity: 5000,
    image_filename: stock_images[:music_festival][:filename]
  },
  {
    name: "Coding Workshop",
    description: %(
      <div>
        <h3>Learn Web Development with Ruby on Rails</h3>
        <p>This <strong>hands-on workshop</strong> teaches the fundamentals of Ruby on Rails development in a supportive environment with experienced mentors.</p>

        <h4>Workshop Curriculum:</h4>
        <ul>
          <li>Setting up your development environment</li>
          <li>Ruby programming fundamentals</li>
          <li>MVC architecture in Rails</li>
          <li>Building your first web application</li>
          <li>Deploying your application</li>
        </ul>

        <p>Perfect for beginners who want to start their journey into web development. All participants will leave with a <em>functioning web application</em> they built themselves!</p>
      </div>
    ),
    start_date: DateTime.now + 15.days,
    end_date: DateTime.now + 15.days + 8.hours,
    location: "Downtown Tech Hub",
    capacity: 50,
    image_filename: stock_images[:coding_workshop][:filename]
  },
  {
    name: "Charity Gala",
    description: %(
      <div>
        <h3>Annual Fundraising Event</h3>
        <p>Join us for an <strong>elegant evening</strong> supporting local community initiatives, featuring a gourmet dinner, live entertainment, and silent auction.</p>

        <h4>Gala Program:</h4>
        <ul>
          <li>Welcome reception with champagne</li>
          <li>Five-course gourmet dinner</li>
          <li>Live entertainment and performances</li>
          <li>Silent and live auctions</li>
          <li>Recognition of community leaders</li>
        </ul>

        <p>All proceeds will benefit our foundation's work in <em>education, healthcare, and community development</em>. Your participation makes a difference!</p>
      </div>
    ),
    start_date: DateTime.now + 45.days + 18.hours,
    end_date: DateTime.now + 45.days + 23.hours,
    location: "Grand Hotel Ballroom",
    capacity: 200,
    image_filename: stock_images[:charity_gala][:filename]
  },
  {
    name: "Business Networking",
    description: %(
      <div>
        <h3>Monthly Professional Connections</h3>
        <p>Connect with <strong>like-minded professionals</strong>, share insights, discover potential partnerships, and expand your network in a relaxed setting.</p>

        <h4>Event Schedule:</h4>
        <ul>
          <li>Structured networking activities</li>
          <li>Short presentations from industry experts</li>
          <li>Refreshments and light appetizers</li>
          <li>Business card exchange</li>
          <li>Follow-up resources and connections</li>
        </ul>

        <p>This month's theme focuses on <em>sustainable business practices</em>. Come prepared to share your experiences and learn from others in the field!</p>
      </div>
    ),
    start_date: DateTime.now + 7.days + 17.hours,
    end_date: DateTime.now + 7.days + 20.hours,
    location: "Executive Lounge",
    capacity: 75,
    image_filename: stock_images[:business_networking][:filename]
  }
]

# Create events and attach images
events_data.each do |event_data|
  image_filename = event_data.delete(:image_filename)
  event = Event.create!(event_data)

  # Attach image to event
  image_path = Rails.root.join("app/assets/images/events/#{image_filename}")
  if File.exist?(image_path)
    event.image.attach(
      io: File.open(image_path),
      filename: image_filename,
      content_type: "image/jpeg"
    )
    puts "✅ Created event: #{event.name} with image"
  else
    puts "❌ Created event: #{event.name} without image (file not found)"
  end
end

puts "Created #{Event.count} events!"
puts "#{Event.joins(:image_attachment).count} events have images attached"
puts "Seed completed successfully!"
