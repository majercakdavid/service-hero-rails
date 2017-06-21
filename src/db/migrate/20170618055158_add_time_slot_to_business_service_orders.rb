class AddTimeSlotToBusinessServiceOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :business_service_orders, :time_slot, index: true
  end
end
