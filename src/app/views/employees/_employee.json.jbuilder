json.extract! employee, :id, :business_id, :billing_address_id, :shipping_address_id, :email, :name, :created_at, :updated_at
json.url employee_url(employee, format: :json)
