class BusinessesController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]
  before_action :authenticate_user!
  before_action :set_business, only: [:show, :edit, :update, :destroy, :get_business_statistics]

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
    @business.billing_address = Address.new
    @business.shipping_address = Address.new
    authorize! :new, @business
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(business_params)
    @business.shipping_address = Address.new(shipping_address_params)
    @business.billing_address = Address.new(billing_address_params)
    @business.date_joined = Time.now
    @association = BusinessBusinessOwner.new(business: @business, business_owner: current_user.role, date_from: Time.now)
    #@business.business_business_owners.business = @business
    #@business.business_business_owners.business_owner = current_user.role
    #@business.business_business_owners.date_from = Time.now

    authorize! :create, @business

    BusinessBusinessOwner.transaction do
      Business.transaction do
        Address.transaction do
          @business.shipping_address.save!
          @business.billing_address.save!
          @business.save!
          @association.save!
        end
      end
    end

    respond_to do |format|
      if @business.persisted?
        format.html {redirect_to dashboard_path, notice: 'Business was successfully created.'}
        format.json {redirect_to dashboard_path, status: :created, location: dashboard_path}
      else
        format.html {render :new}
        format.json {render json: @business.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html {redirect_to dashboard_path, notice: 'Business was successfully updated.'}
        format.json {render :show, status: :ok, location: dashboard_path}
      else
        format.html {render :edit}
        format.json {render json: @business.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html {redirect_to dashboard_path, notice: 'Business was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def get_business_statistics
    @profit = Business.select("sum(business_services.price)")
                  .joins("JOIN business_services ON business_services.business_id = businesses.id")
                  .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                  .where("businesses.id=?", "#{@business[:id]}")
    @annual_profit = Business.select("sum(business_services.price)")
                         .joins("JOIN business_services ON business_services.business_id = businesses.id")
                         .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                         .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", 1.years.ago.beginning_of_year, Time.now.beginning_of_year)
    @monthly_profit = Business.select("sum(business_services.price)")
                          .joins("JOIN business_services ON business_services.business_id = businesses.id")
                          .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                          .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", 1.months.ago.beginning_of_month, Time.now.beginning_of_month)
    @services_count = Business.select("count(*)")
                          .joins("JOIN business_services ON business_services.business_id = businesses.id")
    @employees_count = Business.select("count(*)")
                           .joins("JOIN employees ON employees.business_id = businesses.id")
    @annual_growth = nil
    if @business.date_joined <= 2.years.ago
      @last_year_profit = Business.select("sum(business_services.price)")
                              .joins("JOIN business_services ON business_services.business_id = businesses.id")
                              .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                              .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", 1.years.ago.beginning_of_year, 1.years.ago)
                              .as_json[0]['sum']
      @this_year_profit = Business.select("sum(business_services.price)")
                              .joins("JOIN business_services ON business_services.business_id = businesses.id")
                              .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                              .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", Time.now.beginning_of_year, Time.now)
                              .as_json[0]['sum']
      @annual_growth = (@this_year_profit - @last_year_profit)/@last_year_profit
      @annual_growth = @annual_growth.round(4).to_s + "%"
    end

    @monthly_growth = nil
    if @business.date_joined <= 2.months.ago
      @last_month_profit = Business.select("sum(business_services.price)")
                               .joins("JOIN business_services ON business_services.business_id = businesses.id")
                               .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                               .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", 1.months.ago.beginning_of_month, 1.months.ago)
                               .as_json[0]['sum']
      @this_month_profit = Business.select("sum(business_services.price)")
                               .joins("JOIN business_services ON business_services.business_id = businesses.id")
                               .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
                               .where("businesses.id=? and business_service_orders.date_created>=? and business_service_orders.date_created<?", "#{@business[:id]}", Time.now.beginning_of_month, Time.now)
                               .as_json[0]['sum']
      @monthly_growth = (@this_month_profit - @last_month_profit)/@last_month_profit
      @monthly_growth = @monthly_growth.round(4).to_s + "%"
    end

    render json: {"Profit": @profit.as_json[0]['sum'], "Annual Profit": @annual_profit.as_json[0]['sum'], "Monthly Profit": @monthly_profit.as_json[0]['sum'], "Services Count": @services_count.as_json[0]['count'], "Annual Growth": @annual_growth, "Monthly Growth": @monthly_growth}.as_json(except: [:id])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_business
    @business = Business.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_params
    params.require(:business).permit(:name)
  end

  def shipping_address_params
    params.require(:business).require(:shipping_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

  def billing_address_params
    params.require(:business).require(:billing_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end
end
