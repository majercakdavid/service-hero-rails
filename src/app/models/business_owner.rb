class BusinessOwner < ApplicationRecord
  self.table_name = 'business_owners'

  belongs_to :billing_address, :class_name => 'Address', dependent: :destroy
  belongs_to :shipping_address, :class_name => 'Address', dependent: :destroy

  has_many :documents, :as => :documentable
  has_many :business_business_owners, dependent: :destroy
  has_many :businesses, through: :business_business_owners

  has_many :business_services, through: :businesses

  has_one :user, :as => :role, dependent: :destroy

  accepts_nested_attributes_for :billing_address, :businesses, :documents, :shipping_address, :user
end
