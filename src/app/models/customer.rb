class Customer < ApplicationRecord
  has_secure_password
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :documents, :as => :documentable
end
