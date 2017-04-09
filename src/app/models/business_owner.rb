class BusinessOwner < ApplicationRecord
  self.table_name = 'business_owners'
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :documents, :as => :documentable
  has_one :user, :as => :role, dependent: :destroy
end
