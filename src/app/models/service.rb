class Service < ApplicationRecord
  has_many :documents, :as => :documentable
  has_many :business_services
end
