class TimeSlotsController < ApplicationController
  before_action :set_business, only: [:business_service_time_slots, :time_slottable_business_services]
  before_action :set_time_slot, only: [:update_business_service_time_slot, :destroy_business_service_time_slot, :make_time_slot_reservation]
  before_action :set_business_service, only: [:make_time_slot_reservation]
  load_and_authorize_resource :unless => [:create]

  def time_slottable_business_services
    @business_services = @business.business_services.where(enable_time_slots: true).includes(:business, :service)
  end

  def business_service_time_slots
    @time_slots = nil
    if @business
      @time_slots = @business.time_slots;
    end
  end

  def create_business_service_time_slot
    @time_slot = TimeSlot.new time_slot_params
    if @time_slot.save!
      render :template => 'time_slots/time_slot'
    else
      respond_to do |format|
        format.json {render json: @time_slot.errors, status: :unprocessable_entity}
      end
    end
  end

  def update_business_service_time_slot
    @time_slot.update time_slot_params
    render :template => 'time_slots/time_slot'
  end

  def destroy_business_service_time_slot
    @time_slot.destroy!
  end

  def make_time_slot_reservation
    @business_service_order = BusinessServiceOrder.where(time_slot_id: @time_slot.id)
    if @business_service_order.any?
      @business_service_order = @business_service_order.joins(:order).where("orders.customer_id = #{current_user.role.id}").first
      if !@business_service_order.nil?
        @order = @business_service_order.order
        Order.transaction do
          BusinessServiceOrder.transaction do
            @business_service_order.destroy!
            @order.destroy!
          end
        end
      end
      render :template => 'time_slots/time_slot'
      return
    else
      @business_service_order = BusinessServiceOrder.new
      @business_service_order.business_service = @business_service
      @business_service_order.date_created = Date.today

      @business_service_order.order = Order.new
      @business_service_order.order.customer = current_user.role
      @business_service_order.order.date_created = Date.today
      @business_service_order.time_slot_id = @time_slot.id

      Order.transaction do
        BusinessServiceOrder.transaction do
          @business_service_order.order.save!
          @business_service_order.save!
          @time_slot.save!
        end
      end
    end

    if @business_service_order.persisted?
      render :template => 'time_slots/time_slot'
    else
      respond_to do |format|
        format.json {render json: @business_service_order.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_business
    @business = Business.find(params[:business_id])
  end

  def set_time_slot
    @time_slot = TimeSlot.find(params.require(:time_slot)[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_slot_params
    params.require(:time_slot).permit(:datetime_from, :datetime_to, :business_service_id)
  end

  def set_business_service
    @business_service = TimeSlot.find(params[:time_slot][:id]).business_service
  end
end
