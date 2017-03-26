class BusinessBusinessOwner < ApplicationRecord
  belongs_to :business
  belongs_to :business_owner
end
