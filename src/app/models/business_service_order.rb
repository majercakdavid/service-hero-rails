class BusinessServiceOrder < ApplicationRecord
  belongs_to :business_service
  belongs_to :order
  has_one :time_slot
  has_many :documents, :as => :documentable
end
