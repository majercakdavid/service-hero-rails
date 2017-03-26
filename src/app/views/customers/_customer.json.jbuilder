json.extract! customer, :id, :billing_address_id, :shipping_address_id, :email, :name, :date_joined, :created_at, :updated_at
json.url customer_url(customer, format: :json)
