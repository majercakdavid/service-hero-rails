class CustomersController < ApplicationController
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
    @customer = Customer.new
    @customer.user = User.new
    @customer.shipping_address = Address.new
    @customer.billing_address = Address.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = User.new(user_params)
    @customer.role = Customer.new(customer_params)
    @customer.role.shipping_address = Address.new(shipping_address_params)
    @customer.role.billing_address = Address.new(billing_address_params)

    @customer.role.date_joined = Time.now

    Customer.transaction do
      User.transaction do
        Address.transaction do
          @customer.role.shipping_address.save!
          @customer.role.billing_address.save!
          @customer.role.save!
          @customer.save!
        end
      end
    end

    respond_to do |format|
      if @customer.persisted?
        sign_in(User, @customer)
        format.html { redirect_to dashboard_path, notice: 'Your account was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end

    @customer = Customer.new(customer_params)
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    @responded = false
    respond_to do |format|
      Customer.transaction do
        User.transaction do
          Address.transaction do
            format.html { redirect_to @customer, notice: 'Account was successfully updated.' }
            format.json { render :show, status: :ok, location: @customer }
            @responded = true
          end
        end
      end
      if !@responded
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
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
    params.require(:customer).permit(:name)
  end

  def user_params
    params.require(:customer).require(:user_attributes).permit(:email, :password, :password_confirmation)
  end

  def shipping_address_params
    params.require(:customer).require(:shipping_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

  def billing_address_params
    params.require(:customer).require(:billing_address_attributes)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

end
