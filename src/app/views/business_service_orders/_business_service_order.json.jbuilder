json.extract! business_service_order, :id, :business_service_id, :order_id, :label, :description, :date_created, :created_at, :updated_at
json.url business_service_order_url(business_service_order, format: :json)
