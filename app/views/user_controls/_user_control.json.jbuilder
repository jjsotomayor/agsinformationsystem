json.extract! user_control, :id, :name, :password, :sign_in_count, :created_at, :updated_at
json.url user_control_url(user_control, format: :json)
