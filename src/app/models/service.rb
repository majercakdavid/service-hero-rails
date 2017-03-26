class Service < ApplicationRecord
  has_many :documents, :as => :documentable
end
