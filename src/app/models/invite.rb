class Invite < ApplicationRecord
  belongs_to :business
  belongs_to :sender, class_name: User
  belongs_to :recipient, class_name: User, optional: true
end
