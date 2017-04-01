json.extract! administrator, :id, :email, :name, :password, :password_confirmation,  :created_at, :updated_at
json.url administrator_url(administrator, format: :json)
