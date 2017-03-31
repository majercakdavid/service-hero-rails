json.extract! business_owner, :id, :billing_address, :shipping_address, :email, :name, :created_at, :updated_at
json.url business_owner_url(business_owner, format: :json)
