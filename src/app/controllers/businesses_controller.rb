class BusinessesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, :set_business, only: [:show, :edit, :update, :destroy]

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
    @business.billing_address = Address.new
    @business.shipping_address = Address.new
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

    @business.date_joined = Time.now
    Business.transaction do
      Address.transaction do
        @business.shipping_address.save!
        @business.billing_address.save!
        @business.save!
      end
    end

    respond_to do |format|
      if @business.persisted?
        format.html {redirect_to dashboard_path, notice: 'Business was successfully created.'}
        format.json {render :show, status: :created, location: dashboard_path}
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
      format.html {redirect_to businesses_url, notice: 'Business was successfully destroyed.'}
      format.json {head :no_content}
    end
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
