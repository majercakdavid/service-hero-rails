class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guest user not logged in
    if user.is_administrator?
      can :manage, :all
    elsif user.is_business_owner?
      can :manage, BusinessOwner, :id => user.role.id
      can :manage, Business, :business_owners do |bo|
        user.role.in?(bo.business_owners)
      end
    elsif user.is_employee?
      can :manage, Employee, :id => user.role.id
    elsif user.is_customer?
      can :manage, Customer, :id => user.role.id
    end
  end
end
