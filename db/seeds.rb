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
if User.find_by(email_address: "dhh@hey.com").nil?
  User.create!(email_address: "dhh@hey.com", password: "admin")
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
    description: "Annual technology conference featuring the latest innovations in AI and machine learning. Join us for three days of inspiring keynotes, hands-on workshops, and networking opportunities with industry leaders.",
    start_date: DateTime.now + 30.days,
    end_date: DateTime.now + 32.days,
    location: "San Francisco Convention Center",
    capacity: 500,
    image_filename: stock_images[:tech_conference][:filename]
  },
  {
    name: "Music Festival",
    description: "Three-day outdoor music festival with top artists from around the world. Experience diverse musical genres, food vendors, art installations, and create unforgettable memories with friends.",
    start_date: DateTime.now + 60.days,
    end_date: DateTime.now + 63.days,
    location: "Central Park",
    capacity: 5000,
    image_filename: stock_images[:music_festival][:filename]
  },
  {
    name: "Coding Workshop",
    description: "Hands-on workshop teaching the fundamentals of Ruby on Rails development. Perfect for beginners who want to learn web development in a supportive environment with experienced mentors.",
    start_date: DateTime.now + 15.days,
    end_date: DateTime.now + 15.days + 8.hours,
    location: "Downtown Tech Hub",
    capacity: 50,
    image_filename: stock_images[:coding_workshop][:filename]
  },
  {
    name: "Charity Gala",
    description: "Annual fundraising event supporting local community initiatives. Join us for an elegant evening featuring a gourmet dinner, live entertainment, silent auction, and opportunities to contribute to meaningful causes.",
    start_date: DateTime.now + 45.days + 18.hours,
    end_date: DateTime.now + 45.days + 23.hours,
    location: "Grand Hotel Ballroom",
    capacity: 200,
    image_filename: stock_images[:charity_gala][:filename]
  },
  {
    name: "Business Networking",
    description: "Monthly networking event for entrepreneurs and business professionals. Connect with like-minded individuals, share insights, discover potential partnerships, and expand your professional network in a relaxed setting.",
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
