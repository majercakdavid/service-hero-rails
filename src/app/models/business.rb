class Business < ApplicationRecord
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :documents, :as => :documentable
  has_many :business_services, dependent: :destroy
  has_many :services, through: :business_services
  has_many :business_service_orders, through: :business_services, dependent: :destroy
  has_many :business_business_owners, dependent: :destroy
  has_many :business_owners, through: :business_business_owners
  has_many :time_slots, through: :business_services
  has_many :employees, dependent: :destroy
  has_many :invites, dependent: :destroy

  accepts_nested_attributes_for :billing_address, :shipping_address
end
