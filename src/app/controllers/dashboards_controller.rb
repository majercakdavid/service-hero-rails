class DashboardsController < ApplicationController
  skip_authorization_check :only => [:index]
  before_action :authenticate_user!

  def index
    @user = current_user
    render "#{@user.role.class.name.downcase}_dashboard"
  end

  def latest_businesses_orders
    @user = current_user
    @response = latest_businesses_orders_helper(@user.role).as_json(except: [:id])
    authorize!(:view, @user.role)
    render json: @response
    #json_response @response
=begin
    respond_to do |format|
      format.json {json: @response}
      format.js {}
      format.html {}
    end
=end
  end
  
  private

  def latest_businesses_orders_helper(business_owner)
    BusinessOwner.select("businesses.name, business_service_orders.label, business_services.price, business_service_orders.date_created")
        .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
        .joins("JOIN businesses ON businesses.id = business_business_owners.business_id")
        .joins("JOIN business_services ON business_services.business_id = businesses.id")
        .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
        .where("business_owners.id = #{business_owner.id}")
        .order("business_service_orders.date_created DESC")
  end
end
