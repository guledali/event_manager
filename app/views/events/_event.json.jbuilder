json.extract! event, :id, :name, :description, :start_date, :end_date, :location, :capacity, :created_at, :updated_at
json.url event_url(event, format: :json)
