class BusinessServiceOrdersController < ApplicationController
  before_action :authenticate_user!, :set_business_service_order, only: [:show, :edit, :update, :destroy]

  # GET /business_service_orders
  # GET /business_service_orders.json
  def index
    @business_service_orders = BusinessServiceOrder.all
  end

  # GET /business_service_orders/1
  # GET /business_service_orders/1.json
  def show
  end

  # GET /business_service_orders/new
  def new
    @business_service_order = BusinessServiceOrder.new
  end

  # GET /business_service_orders/1/edit
  def edit
  end

  # POST /business_service_orders
  # POST /business_service_orders.json
  def create
    @business_service_order = BusinessServiceOrder.new(business_service_order_params)

    respond_to do |format|
      if @business_service_order.save
        format.html { redirect_to @business_service_order, notice: 'Business service order was successfully created.' }
        format.json { render :show, status: :created, location: @business_service_order }
      else
        format.html { render :new }
        format.json { render json: @business_service_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_service_orders/1
  # PATCH/PUT /business_service_orders/1.json
  def update
    respond_to do |format|
      if @business_service_order.update(business_service_order_params)
        format.html { redirect_to @business_service_order, notice: 'Business service order was successfully updated.' }
        format.json { render :show, status: :ok, location: @business_service_order }
      else
        format.html { render :edit }
        format.json { render json: @business_service_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_service_orders/1
  # DELETE /business_service_orders/1.json
  def destroy
    @business_service_order.destroy
    respond_to do |format|
      format.html { redirect_to business_service_orders_url, notice: 'Business service order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_service_order
      @business_service_order = BusinessServiceOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_service_order_params
      params.require(:business_service_order).permit(:business_service_id, :order_id, :label, :description, :date_created)
    end
end
