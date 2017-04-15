class EmployeesController < ApplicationController
  before_action :authenticate_user!, :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :extract_token, only: [:new, :create]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @invitation = Invite.find_by token: @token
    if @invitation.nil?
      format.html { redirect_to root_path, notice: 'Employee cannot be created.' }
      format.json { render :show, status: :unprocessable_entity, location: @employee }
    else
      @employee = Employee.new
    end
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @token = params[:invite_token]
    if @token.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Employee cannot be created.' }
        format.json { render :show, status: :unprocessable_entity, location: @employee }
      end
    else
      @employee = User.new(user_params)
      @employee.role = Employee.new(employee_params)
      @employee.role.shipping_address = Address.new(shipping_address_params)
      @employee.role.billing_address = Address.new(billing_address_params)

      @invitation = Invite.find_by token: @token
      @employee.role.business = @invitation.business

      Employee.transaction do
        User.transaction do
          Address.transaction do
            @employee.role.shipping_address.save!
            @employee.role.billing_address.save!
            @employee.role.save!
            @employee.save!
          end
        end
      end

      respond_to do |format|
        if @employee.persisted?
          format.html { redirect_to root_path, notice: 'Employee was successfully created.' }
          format.json { render :show, status: :created, location: @employee }
        else
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:name)
  end

  def user_params
    params.require(:employee).require(:user).permit(:email, :password, :password_confirmation)
  end

  def shipping_address_params
    params.require(:employee).require(:shipping_address)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

  def billing_address_params
    params.require(:employee).require(:billing_address)
        .permit(:name, :street, :city, :ZIP, :state, :country, :phone)
  end

  def extract_token
    @token = params.permit(:invite_token)[:invite_token]
  end
end
