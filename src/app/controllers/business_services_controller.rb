class BusinessServicesController < ApplicationController
  before_action :authenticate_user!, :set_business_service, only: [:show, :edit, :update, :destroy]
  before_action :set_business, only: [:index, :get_business_services, :create]
  before_action :set_service, only: [:create, :update]

  load_and_authorize_resource :except => [:get_business_services, :create]
  autocomplete :service, :label, :full => true, :extra_data => [:id]

  # GET /business_services
  # GET /business_services.json
  def index
    if current_user.is_business_owner?
      @business_owner = current_user.role
    else
      @business_owner = nil
    end

    if @business_owner
      @business_services = @business.business_services.select(:id, :price, :date_added, :business_id, :service_id, :enable_time_slots).joins(:service).select("services.label").joins(:business).select("businesses.name")
    else
      @business_services = BusinessService.all
    end
  end

  def get_business_services
    @params = business_business_services_params
    if current_user.is_business_owner?
      @business_owner = current_user.role
    else
      @business_owner = nil
    end

    if @business_owner
      @business_services = @business.services.select("services.label AS service_label", "business_services.id", "business_services.price AS price", "business_services.date_added AS date_added")
                               .order("business_services.date_added DESC")
                               .offset(@params[:offset]).limit(@params[:count])
    else
      @business_services = Services.select("services.label AS service_label", "business_services.id", "business_services.price AS price", "business_services.date_added AS date_added")
                               .joins("JOIN business_services ON business_services.service_id = services.id")
                               .order("business_services.date_added DESC")
                               .offset(@params[:offset]).limit(@params[:count])
    end

    @items = @business_services.as_json
    @count = @business.business_services.select(:id).count
    @columns = {
        :service_label => {:label => "Service label", :queriable => true},
        :price => {:label => "Price", :queriable => false},
        :date_added => {:label => "Date", :queriable => false},
        :edit_url => {:label => "Edit", :queriable => false}
    }

    @items.each do |item|
      item['edit_url'] = [edit_business_service_path(item['id']), "Edit"]
    end

    authorize!(:get_business_services, @business_services, current_user)
    render json: {items: @items, columns: @columns, count: @count}.as_json(except: [:id, 'id'])
  end

  # GET /business_services/1
  # GET /business_services/1.json
  def show
  end

  # GET /business_services/new
  def new
    @business_service = BusinessService.new
    @business_service.business = Business.new
    if current_user.is_business_owner?
      @business_service.business = current_user.role.businesses.first_or_create
    end
    @business_service.service = Service.new
  end

  # GET /business_services/1/edit
  def edit
  end

  # POST /business_services
  # POST /business_services.json
  def create
    @business_service = BusinessService.new(business_service_params)
    @business_service.service = @service
    @business_service.business = @business
    @business_service.date_added = Time.now
    authorize! :create, @business_service

    Service.transaction do
      Business.transaction do
        @business_service.service.save!
        @business_service.save!
      end
    end

    respond_to do |format|
      if @business_service.persisted?
        format.html {redirect_to dashboard_path, notice: 'Business service was successfully created.'}
        format.json {render :show, status: :created, location: @business_service}
      else
        format.html {render :new}
        format.json {render json: @business_service.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /business_services/1
  # PATCH/PUT /business_services/1.json
  def update
    respond_to do |format|
      if @business_service.update(business_service_params)
        if @business_service.service.update(service_params)
          format.html {redirect_to @business_service.business, notice: 'Business service was successfully updated.'}
          format.json {render :show, status: :ok, location: @business_service}
        else
          format.html {render :edit}
          format.json {render json: @business_service.errors, status: :unprocessable_entity}
        end
      else
        format.html {render :edit}
        format.json {render json: @business_service.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /business_services/1
  # DELETE /business_services/1.json
  def destroy
    @business_service.destroy
    respond_to do |format|
      format.html {redirect_to business_services_url, notice: 'Business service was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_business_service
    @business_service = BusinessService.find(params[:id])
  end

  def set_business
    @business = Business.find(business_params[:id])
  end

  def set_service
    if !service_params[:id].nil? && !service_params[:id].empty?
      @service = Service.find(service_params[:id])
    else
      @service = Service.new service_params
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_service_params
    params.require(:business_service).permit(:price, :enable_time_slots)
  end

  def business_params
    params.require(:business_service).require(:business_attributes).permit(:id)
  end

  def business_business_services_params
    params.permit(:offset, :count)
  end

  def service_params
    params.require(:business_service).require(:service_attributes).permit(:label, :description, :id)
  end
end
