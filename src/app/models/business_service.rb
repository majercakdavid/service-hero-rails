class BusinessService < ApplicationRecord
  belongs_to :business
  belongs_to :service
  has_many :documents, :as => :documentable
end
