class Order < ApplicationRecord
  belongs_to :customer
  has_many :business_service_orders
end
