class BusinessService < ApplicationRecord
  belongs_to :business
  belongs_to :service
  belongs_to :order
  has_many :documents, :as => :documentable, dependent: :destroy
  has_many :business_service_orders
end
