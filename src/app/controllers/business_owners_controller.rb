class BusinessOwnersController < ApplicationController
  skip_authorization_check :only => [:new, :create]
  load_and_authorize_resource :only => [:edit, :update, :destroy, :new_employee, :invite_employee]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new_employee, :invite_employee]
  before_action :set_business_owner, only: [:edit, :update, :destroy]

  # GET /business_owners/new
  def new
    @business_owner = User.new
    @business_owner.role = BusinessOwner.new
    @business_owner.role.shipping_address = Address.new
    @business_owner.role.billing_address = Address.new
  end

  # GET /business_owners/1/edit
  def edit
  end

  # POST /business_owners
  # POST /business_owners.json
  def create
    @business_owner = User.new
    @business_owner.role_type = BusinessOwner.name
    @business_owner.update business_owner_params
    respond_to do |format|
      if @business_owner.save
        sign_in(User, @business_owner)
        format.html {redirect_to dashboard_url, notice: 'Your account was successfully created.'}
        format.json {render :show, status: :created, location: dashboard_path}
      else
        format.html {render :new}
        format.json {render json: @business_owner.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /business_owners/1
  # PATCH/PUT /business_owners/1.json
  def update
    respond_to do |format|
      if @business_owner.update business_owner_params
        sign_in(User, @business_owner)
        format.html {redirect_to dashboard_path, notice: 'Account was successfully updated.'}
        format.json {render :show, status: :ok, location: dashboard_path}
      else
        format.html {render :edit}
        format.json {render json: @business_owner.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /business_owners/1
  # DELETE /business_owners/1.json
  def destroy
    @business_owner.destroy
    respond_to do |format|
      format.html {redirect_to root_path, notice: 'Business owner was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  # POST /business_owners/new_employee
  def new_employee
    if current_user.role.businesses.none?
      respond_to do |format|
        format.html {redirect_to dashboard_path, notice: 'Business must be created before employee.'}
        format.json {render json: @business_owner.errors, status: :unprocessable_entity}
      end
    end

    @invite = Invite.new
    @invite.sender = current_user
  end

  # POST /business_owners/invite_employee
  def invite_employee
    @invite = Invite.new(invite_params)
    #@invite.business = Business.find(invite_params[:id])
    @invite.token = generate_token
    @invite.sender = current_user
    @invite.recipient_id = nil

    respond_to do |format|
      if @invite.save!
        InvitationMailer.new_employee_invite(@invite, employees_register_url(:invite_token => @invite.token)).deliver
        format.html {redirect_to dashboard_path, notice: 'Employee was successfully invited.'}
        format.json {render :show, status: :ok, location: dashboard_path}
      else
        format.html {render :new_employee}
        format.json {render json: @business_owner.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_business_owner
    @role = BusinessOwner.find(params[:id])
    @business_owner = @role.user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_owner_params
    if params.require(:user)[:password].nil? || params.require(:user)[:password].empty?
      params.require(:user).permit(:email,
                                   :role_attributes => [:name, :shipping_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                        :billing_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone]])
    else
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :role_attributes => [:name, :shipping_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                        :billing_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone]])
    end
  end

  def invite_params
    params.require(:invite).permit(:email, :business_id)
  end

  def generate_token
    Digest::SHA2.new(512).hexdigest([current_user.role.id, Time.now, rand].join)
  end
end
