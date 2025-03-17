# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'

# Clear existing events to avoid duplicates when re-seeding
Event.destroy_all

puts "Creating events..."

# Let's create events without images first
events = [
  {
    name: "Tech Conference 2025",
    description: "Annual technology conference featuring the latest innovations in AI and machine learning. Join us for three days of inspiring keynotes, hands-on workshops, and networking opportunities with industry leaders.",
    start_date: DateTime.now + 30.days,
    end_date: DateTime.now + 32.days,
    location: "San Francisco Convention Center",
    capacity: 500
  },
  {
    name: "Music Festival",
    description: "Three-day outdoor music festival with top artists from around the world. Experience diverse musical genres, food vendors, art installations, and create unforgettable memories with friends.",
    start_date: DateTime.now + 60.days,
    end_date: DateTime.now + 63.days,
    location: "Central Park",
    capacity: 5000
  },
  {
    name: "Coding Workshop",
    description: "Hands-on workshop teaching the fundamentals of Ruby on Rails development. Perfect for beginners who want to learn web development in a supportive environment with experienced mentors.",
    start_date: DateTime.now + 15.days,
    end_date: DateTime.now + 15.days + 8.hours,
    location: "Downtown Tech Hub",
    capacity: 50
  },
  {
    name: "Charity Gala",
    description: "Annual fundraising event supporting local community initiatives. Join us for an elegant evening featuring a gourmet dinner, live entertainment, silent auction, and opportunities to contribute to meaningful causes.",
    start_date: DateTime.now + 45.days + 18.hours,
    end_date: DateTime.now + 45.days + 23.hours,
    location: "Grand Hotel Ballroom",
    capacity: 200
  },
  {
    name: "Business Networking",
    description: "Monthly networking event for entrepreneurs and business professionals. Connect with like-minded individuals, share insights, discover potential partnerships, and expand your professional network in a relaxed setting.",
    start_date: DateTime.now + 7.days + 17.hours,
    end_date: DateTime.now + 7.days + 20.hours,
    location: "Executive Lounge",
    capacity: 75
  }
]

# Create events
Event.create!(events)

puts "Created #{Event.count} events! Note: You can add images through the UI by editing each event."
