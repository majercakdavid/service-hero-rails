class BusinessOwnersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new_employee, :invite_employee]
  before_action :set_business_owner, only: [:edit, :update, :destroy]

  # GET /business_owners/new
  def new
    @business_owner = BusinessOwner.new
    @business_owner.user = User.new
    @business_owner.shipping_address = Address.new
    @business_owner.billing_address = Address.new
  end

  # GET /business_owners/1/edit
  def edit
  end

  # POST /business_owners
  # POST /business_owners.json
  def create
    @business_owner = User.new(user_params)
    @business_owner.role = BusinessOwner.new(business_owner_params)
    @business_owner.role.shipping_address = Address.new(shipping_address_params)
    @business_owner.role.billing_address = Address.new(billing_address_params)

    BusinessOwner.transaction do
      User.transaction do
        Address.transaction do
          @business_owner.role.shipping_address.save!
          @business_owner.role.billing_address.save!
          @business_owner.role.save!
          @business_owner.save!
        end
      end
    end

    respond_to do |format|
      if @business_owner.persisted?
        format.html { redirect_to dashboard_path, notice: 'Your account was successfully created.' }
        format.json { render :show, status: :created, location: @business_owner }
      else
        format.html { render :new }
        format.json { render json: @business_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_owners/1
  # PATCH/PUT /business_owners/1.json
  def update
    @responded = false
    respond_to do |format|
      BusinessOwner.transaction do
        User.transaction do
          Address.transaction do
            format.html { redirect_to @business_owner, notice: 'Account was successfully updated.' }
            format.json { render :show, status: :ok, location: @business_owner }
            @responded = true
          end
        end
      end
      if !@responded
        format.html { render :edit }
        format.json { render json: @business_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_owners/1
  # DELETE /business_owners/1.json
  def destroy
    @business_owner.destroy
    respond_to do |format|
      format.html { redirect_to business_owners_url, notice: 'Business owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /business_owners/new_employee
  def new_employee
    @credentials = ApplicationRecord.new
  end

  # POST /business_owners/invite_employee
  def invite_employee
    redirect_to dashboard_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_business_owner
    @role = BusinessOwner.find(params[:id])
    @business_owner = @role.user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_owner_params
    params.require(:business_owner).permit(:name)
  end

  def user_params
    params.require(:business_owner).require(:user_attributes).permit(:email, :password, :password_confirmation)
  end

  def shipping_address_params
    params.require(:business_owner).require(:shipping_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

  def billing_address_params
    params.require(:business_owner).require(:billing_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end
end
