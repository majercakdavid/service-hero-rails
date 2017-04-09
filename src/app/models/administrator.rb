class Administrator < ApplicationRecord
  self.table_name = 'administrators'
  has_many :documents, :as => :documentable
  has_one :user, :as => :role, dependent: :destroy
end
