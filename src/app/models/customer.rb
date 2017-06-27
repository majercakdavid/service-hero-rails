class Customer < ApplicationRecord
  self.table_name = 'customers'

  #belongs_to :user, dependent: :destroy, polymorphic: true

  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'

  has_many :documents, :as => :documentable
  has_many :orders, dependent: :destroy
  has_many :business_service_orders, through: :orders, dependent: :destroy

  has_one :user, :as => :role, dependent: :destroy

  accepts_nested_attributes_for :user, :documents, :billing_address, :shipping_address
end
