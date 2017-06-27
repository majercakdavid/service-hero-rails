class CustomersController < ApplicationController
  skip_authorization_check :only => [:new, :create]
  load_and_authorize_resource :only => [:edit, :update, :destroy]
  before_action :authenticate_user!, :set_customer, only: [:edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all.includes(:billing_address, :shipping_address)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = User.new
    @customer.role = User.new
    @customer.role.shipping_address = Address.new
    @customer.role.billing_address = Address.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = User.new
    @customer.role_type = Customer.name
    @customer.update customer_params
    respond_to do |format|
      if @customer.save
        sign_in(User, @customer)
        format.html { redirect_to dashboard_url, notice: 'Your account was successfully created.' }
        format.json { render :show, status: :created, location: dashboard_url }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update customer_params
        format.html { redirect_to dashboard_path, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.role.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @role = Customer.find(params[:id])
    @customer = @role.user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
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
end
