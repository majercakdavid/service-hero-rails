json.extract! business_service, :id, :business_id, :service_id, :price, :date_added, :created_at, :updated_at
json.url business_service_url(business_service, format: :json)
