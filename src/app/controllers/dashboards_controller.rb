class DashboardsController < ApplicationController
  skip_authorization_check :only => [:index]
  before_action :authenticate_user!

  def index
    @user = current_user
    render "#{@user.role.class.name.downcase}_dashboard"
  end

  def get_most_profitable_businesses
    @params = orders_params
    @items = Business.select("businesses.name, businesses.id, sum(business_services.price)")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                 .group("businesses.name, businesses.id").having("businesses.name ILIKE ?", "%#{@params[:query]}%")
                 .order("2 DESC")
                 .offset(@params[:offset]).limit(@params[:count]).as_json
    @count = Business.select("count(*)")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
    @columns = [Business.name.humanize, "Profit", "View"]

    @items.each do |item|
      item['edit_url'] = [business_url(item['id']), "View"]
    end

    authorize!(:get_my_businesses, current_user)
    render json: {items: @items, columns: @columns, count: @count}.as_json(except: [:id, 'id'])
  end

  def get_latest_businesses_orders
    @params = orders_params
    @response = latest_businesses_orders_helper(current_user.role, @params[:offset], @params[:count]).as_json(except: [:id])
    authorize!(:get_latest_businesses_orders, current_user)
    render json: @response
  end

  def get_my_businesses
    @params = orders_params
    @response = my_businesses_helper(current_user.role, @params[:offset], @params[:count]).as_json(except: [:id])
    authorize!(:get_my_businesses, current_user)
    render json: @response
  end

  private

  def latest_businesses_orders_helper(business_owner, offset, count)
    @items = BusinessOwner.select("businesses.name, business_service_orders.label, business_services.price, business_service_orders.date_created")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON businesses.id = business_business_owners.business_id")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")
                 .order("business_service_orders.date_created DESC")
                 .offset(offset).limit(count)

    @count = BusinessOwner.select("count(*)")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON businesses.id = business_business_owners.business_id")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")

    @columns = [Business.name.humanize, Service.name.humanize, "Price", "Date Ordered"]
    return {items: @items, columns: @columns, count: @count}
  end

  def my_businesses_helper(business_owner, offset, count)
    @items = BusinessOwner.select("businesses.name, sum(business_services.price)")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON business_business_owners.business_id = businesses.id")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("JOIN business_service_orders ON business_service_orders. business_service_id = business_services.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")
                 .group("businesses.name")
                 .offset(offset).limit(count)
    @count = BusinessOwner.select("count(*)")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON business_business_owners.business_id = businesses.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")
    @columns = [Business.name.humanize, "Profit"]
    return {items: @items, columns: @columns, count: @count}
  end

  def orders_params
    params.permit(:query, :offset, :count)
  end
end
