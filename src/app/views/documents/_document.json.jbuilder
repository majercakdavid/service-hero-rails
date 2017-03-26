json.extract! document, :id, :owner_id, :belongs_to, :label, :data, :dataurl, :description, :created_at, :updated_at
json.url document_url(document, format: :json)
