class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({role_type: params[:role]})
    #resource.role = params[:role].constantize.new
    if (params[:role] == BusinessOwner.name)
      resource.role = BusinessOwner.new
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
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
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
  def destroy
    super
  end

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
                                                :billing_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone]]).merge(role_type: BusinessOwne.name)
      elsif params[:role] == Customer.name
        user_params.permit(:email, :password, :password_confirmation,
                           :role_attributes => [:name,
                                                :billing_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone],
                                                :shipping_address_attributes => [:name, :street, :city, :ZIP, :state, :country, :phone]]).merge(role_type: Customer.name)
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
