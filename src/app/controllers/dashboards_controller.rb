class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    render "#{@user.role.class.name.downcase}_dashboard"
  end
end
