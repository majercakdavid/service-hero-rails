class Employee < ApplicationRecord
  self.table_name = 'employees'
  belongs_to :business
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :documents, :as => :documentable
  has_one :user, :as => :role, dependent: :destroy
end
