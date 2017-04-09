class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  ROLE_TYPES = %w(Administrator, BusinessOwner, Employee, Customer)
  belongs_to :role, polymorphic: true
  has_many :addresses, through: :role
  before_create :build_role
  accepts_nested_attributes_for :role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
