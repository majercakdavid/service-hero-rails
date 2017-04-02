class SessionsController < ApplicationController
  def new
  end

  def create
    user = Administrator.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Admin's, Business Owner's, Employee's and Customer's dashboard
      log_in user
      redirect_to user
    else
      user = BusinessOwner.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        # Business Owner's, Employee's amd Customer's dashboard
        log_in user
        redirect_to user
      else
        #user = Employee.find_by(email: params[:session][:email].downcase)
        #if user && user.authenticate(params[:session][:password])
          # Employee's amd Customer's dashboard
        #else
          user = Customer.find_by(email: params[:session][:email].downcase)
          if user && user.authenticate(params[:session][:password])
            # Customer's dashboard
            log_in user
            redirect_to user
          else
            flash.now[:danger] = 'Invalid combination of the email/password'
            render 'new'
          end
        #end
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private
  def session_params
    params.permit(:email, :password)
  end
end
