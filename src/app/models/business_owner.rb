class BusinessOwner < ApplicationRecord
  self.table_name = 'business_owners'

  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'

  has_many :documents, :as => :documentable
  has_many :business_business_owners, dependent: :destroy
  has_many :businesses, through: :business_business_owners

  has_one :user, :as => :role, dependent: :destroy

  accepts_nested_attributes_for :user, :documents, :shipping_address, :billing_address
end
