class Administrator < ApplicationRecord
  self.table_name = 'administrators'
  has_many :documents, :as => :documentable, dependent: :destroy
  has_many :businesses
  has_one :user, :as => :role, dependent: :destroy
  accepts_nested_attributes_for :user
end
