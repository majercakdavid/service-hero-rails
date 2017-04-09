class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({})
    if(params[:role] == Administrator.name)
      resource.role = Administrator.new
    elsif (params[:role] == BusinessOwner.name)
      resource.role = BusinessOwner.new
      resource.role.shipping_address = Address.new
      resource.role.billing_address = Address.new
    elsif (params[:role] == Employee.name)
      resource.role = Employee.new
      resource.role.shipping_address = Address.new
      resource.role.billing_address = Address.new
    elsif (params[:role] == Customer.name)
      resource.role = Customer.new
      resource.role.shipping_address = Address.new
      resource.role.billing_address = Address.new
    end
    yield resource if block_given?
    respond_with resource
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation)
      if params[:role] == BusinessOwner.name
        user_params.permit(:email, :password, :password_confirmation,
                           :role_attributes => [:name,
                                                :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone]])
      elsif params[:role] == Customer.name
        user_params.permit(:email, :password, :password_confirmation,
                           :role_attributes => [:name,
                                                :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone]])
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      if resource.role.class.name == Administrator.name
        user_params.permit(:email, :password, :password_confirmation, :current_password, :role_attributes => [:name, :id])
      elsif resource.role.class.name == BusinessOwner.name
        user_params.permit(:email, :password, :password_confirmation, :current_password,
                           :role_attributes => [:name, :id,
                                                :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone]])
      elsif resource.role.class.name == Employee.name
        user_params.permit(:email, :password, :password_confirmation, :current_password,
                           :role_attributes => [:name, :id,
                                                :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone]])
      elsif resource.role.class.name = Customer.name
        user_params.permit(:email, :password, :password_confirmation, :current_password,
                           :role_attributes => [:name, :id,
                                                :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone]])
      end
    end
  end

  def configure_role_params
    params.require(:user).require(:role_attributes).permit(:name, :id,
                  :billing_address => [:name, :street, :city, :ZIP, :state, :country, :phone],
                  :shipping_address => [:name, :street, :city, :ZIP, :state, :country, :phone])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    '/dashboard'
    #super(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
