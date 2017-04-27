class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guest user not logged in
    if user.is_administrator?
      can :manage, :all
    elsif user.is_business_owner?
      can :manage, BusinessOwner, :id => user.role.id
      can [:edit, :update], Business, :business_owners do |bo|
        user.role.in?(bo.business_owners)
      end
      can [:new, :create], Business
      can :get_latest_businesses_orders, :all
      can :get_my_businesses, :all
    elsif user.is_employee?
      can :manage, Employee, :id => user.role.id
    elsif user.is_customer?
      can :manage, Customer, :id => user.role.id
    end
  end
end