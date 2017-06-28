class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guest user not logged in
    can :filtered_business_services, :all
    if user.is_administrator?
      can :manage, :all
    elsif user.is_business_owner?
      can :manage, BusinessOwner, :id => user.role.id
      can :manage, Business, :business_owners do |bo|
        user.role.in?(bo.business_owners)
      end
      can [:new, :create], Business
      can [:new, :create], BusinessService
      can :get_latest_businesses_orders, :all
      can :get_business_services, :all
      can :get_my_businesses, :all
      can :manage, BusinessService, ["business_id in (?)", user.role.businesses] do |bs|
        bs.business.in?(user.role.businesses)
      end
      can :manage, TimeSlot, ["business_service_id in (?)", user.role.business_services] do |ts|
        ts.business_service.in?(user.role.business_services)
      end
      can :show, Customer
      #can :manage, BusinessService, :id do |bs|
      #  bs.in?(user.role.business_services)
      #end
    elsif user.is_employee?
      can :manage, Employee, :id => user.role.id
    elsif user.is_customer?
      can :manage, Customer, :id => user.role.id
      can :show, Business
      can [:business_service_time_slots, :make_time_slot_reservation], TimeSlot
    end
  end
end
