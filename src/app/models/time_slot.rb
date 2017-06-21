class TimeSlot < ApplicationRecord
  belongs_to :business_service
  belongs_to :business_service_order
  has_many :customers, through: :business_service
end
