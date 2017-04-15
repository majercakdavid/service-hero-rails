class Business < ApplicationRecord
  belongs_to :administrator
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :documents, :as => :documentable
  has_many :business_services, dependent: :destroy
  has_many :business_service_orders, through: :business_services, dependent: :destroy
end
