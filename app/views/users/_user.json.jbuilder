json.extract! user, :id, :name, :email, :user_type, :credit, :followers_count, :created_at, :updated_at
json.url user_url(user, format: :json)
