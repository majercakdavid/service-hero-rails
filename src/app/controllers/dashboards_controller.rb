class DashboardsController < ApplicationController
  skip_authorization_check :only => [:index]
  before_action :authenticate_user!

  def index
    @user = current_user
    render "#{@user.role.class.name.downcase}_dashboard"
  end

  def get_most_profitable_businesses
    @params = orders_params
    @items = Business.select("businesses.name AS business_name, businesses.id, sum(business_services.price) AS profit")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                 .where("businesses.name ILIKE ?", "%#{@params[:query]}%")
                 .group("2,1")
                 .order("2 DESC")
                 .offset(@params[:offset]).limit(@params[:count]).as_json
    @count = Business.select("count(businesses.id)")
                 .joins("JOIN business_services ON business_services.business_id = businesses.id")
    @columns = {
        :business_name => {:label => "Business name", :queriable => true},
        :profit => {:label => "Profit", :queriable => false},
        :view_url => {:label => "Business view", :queriable => false}
    }

    @items.each do |item|
      item['view_url'] = [business_url(item['id']), "View"]
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
    @response = businesses_owner_businesses(current_user.role, @params[:offset], @params[:count]).as_json(except: [:id, 'id'])
    authorize!(:get_my_businesses, current_user)
    render json: @response
  end

  def filtered_business_services
    @columns = {
        :business_name => {:label => "Business name", :queriable => true},
        :service_label => {:label => "Service label", :queriable => true},
        :price => {:label => "Price", :queriable => false},
        :description => {:label => "Description", :queriable => true},
        :view_url => {:label => "Business view", :queriable => false}
    }

    @items = BusinessService
                 .select("business_services.business_id AS id, businesses.name AS business_name, services.label AS service_label, business_services.price AS price, services.description AS description")
                 .joins(:service).joins(:business)
    if (!params[:query].nil?) && (!(params[:query].is_a? String))
      if !get_filter[:business_name].nil?
        @items = @items.where("businesses.name ILIKE ?", "%#{get_filter[:business_name]}%")
      end
      if !get_filter[:service_label].nil?
        @items = @items.where("services.label ILIKE ?", "%#{get_filter[:service_label]}%")
      end
      if !get_filter[:description].nil?
        @items = @items.where("services.description ILIKE ?", "%#{get_filter[:description]}%")
      end
      if !get_filter[:price].nil?
        @items = @items.where("business_service.price = ?", "#{get_filter[:price]}")
      end
    end
    @items = @items.order("1 DESC").offset(params[:offset]).limit(params[:count]).as_json
    @items.each do |item|
      item['view_url'] = [business_url(item['id']), "View"]
    end

    @count = BusinessService.all.count

    authorize!(:filtered_business_services, current_user)
    render json: {items: @items, columns: @columns, count: @count}.as_json(except: [:id, 'id'])
  end

  private

  def latest_businesses_orders_helper(business_owner, offset, count)
    @items = BusinessOwner.select("businesses.name AS business_name, business_service_orders.label AS service_label, business_services.price AS price, business_service_orders.date_created AS date_ordered")
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

    @columns = {
        :business_name => {:label => "Business name", :queriable => true},
        :service_label => {:label => "Service label", :queriable => true},
        :price => {:label => "Price", :queriable => false},
        :date_ordered => {:label => "Date Ordered", :queriable => false}
    }
    return {items: @items, columns: @columns, count: @count}
  end

  def businesses_owner_businesses(business_owner, offset, count)
    @items = BusinessOwner.select("businesses.name AS business_name, businesses.id, COALESCE(sum(business_services.price), 0) AS profit")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON business_business_owners.business_id = businesses.id")
                 .joins("LEFT JOIN business_services ON business_services.business_id = businesses.id")
                 .joins("LEFT JOIN business_service_orders ON business_service_orders. business_service_id = business_services.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")
                 .group("2,1")
                 .offset(offset).limit(count).as_json
    @count = BusinessOwner.select("count(businesses.id)")
                 .joins("JOIN business_business_owners ON business_business_owners.business_owner_id = business_owners.id")
                 .joins("JOIN businesses ON business_business_owners.business_id = businesses.id")
                 .where("business_owners.id = ?", "#{business_owner.id}")
    @columns = {
        :business_name => {:label => "Business name", :queriable => true},
        :profit => {:label => "Profit", :queriable => false},
        :view_url => {:label => "Business view", :queriable => false}
    }

    @items.each do |item|
      item['view_url'] = [business_url(item['id']), "View"]
    end
    return {items: @items, columns: @columns, count: @count}
  end

  def orders_params
    params.permit(:query, :offset, :count)
  end

  def get_filter
    if !params[:query].nil?
      params.require(:query).permit(:business_name, :service_label, :price, :description)
    else
      return []
    end
  end
end
