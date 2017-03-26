class BusinessOwnersController < ApplicationController
  before_action :set_business_owner, only: [:show, :edit, :update, :destroy]

  # GET /business_owners
  # GET /business_owners.json
  def index
    @business_owners = BusinessOwner.all
  end

  # GET /business_owners/1
  # GET /business_owners/1.json
  def show
  end

  # GET /business_owners/new
  def new
    @business_owner = BusinessOwner.new
  end

  # GET /business_owners/1/edit
  def edit
  end

  # POST /business_owners
  # POST /business_owners.json
  def create
    @business_owner = BusinessOwner.new(business_owner_params)

    respond_to do |format|
      if @business_owner.save
        format.html { redirect_to @business_owner, notice: 'Business owner was successfully created.' }
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
    respond_to do |format|
      if @business_owner.update(business_owner_params)
        format.html { redirect_to @business_owner, notice: 'Business owner was successfully updated.' }
        format.json { render :show, status: :ok, location: @business_owner }
      else
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_owner
      @business_owner = BusinessOwner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_owner_params
      params.require(:business_owner).permit(:references, :references, :email, :password, :password_confirmation, :name)
    end
end
