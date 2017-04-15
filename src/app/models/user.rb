class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :role, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :role

  ROLE_TYPES = %w(Customer BusinessOwner)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def build_role(params)
    raise "Unknown client_type: #{role_type}" unless ROLE_TYPES.include?(role_type)
    self.role = role_type.constantize.new(params)
  end
end
