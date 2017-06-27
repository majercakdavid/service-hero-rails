class BusinessService < ApplicationRecord
  belongs_to :business
  belongs_to :service
  has_many :orders, through: :business_service_orders, dependent: :destroy
  has_many :documents, :as => :documentable, dependent: :destroy
  has_many :business_business_owners, through: :business
  has_many :business_service_orders, dependent: :destroy
  has_many :business_owners, through: :business_business_owners
  has_many :customers, through: :business_service_orders
  has_many :time_slots, dependent: :destroy

  accepts_nested_attributes_for :service, :business
end
