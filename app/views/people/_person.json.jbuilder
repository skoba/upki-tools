json.extract! person, :id, :name, :organization, :email, :created_at, :updated_at
json.url person_url(person, format: :json)
