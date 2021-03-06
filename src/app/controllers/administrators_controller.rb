class AdministratorsController < ApplicationController
  before_action :authenticate_user!, :set_administrator, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  # GET /administrators/1
  # GET /administrators/1.json
  def show
  end

  # GET /administrators/1/edit
  def edit
  end

  # PATCH/PUT /administrators/1
  # PATCH/PUT /administrators/1.json
  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        flash[:success] = 'Administrator was successfully updated.'
        format.html { redirect_to dashboard_url, notice: 'Administrator was successfully updated.' }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :edit }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.json
  def destroy
    @administrator.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(User.name)
    yield @administrator if block_given?
    respond_to do |format|
      flash[:success] = 'Administrator was successfully destroyed.'
      format.html { redirect_to administrators_url, notice: 'Administrator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def administrator_params
    params.require(:administrator).permit(:name)
  end

  def administrator_user_params
    params.require(:administrator).require(:user).permit(:email, :password, :password_confirmation)
  end
end
