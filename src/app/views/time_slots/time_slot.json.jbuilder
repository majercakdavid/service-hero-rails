date_format = '%Y-%m-%dT%H:%M:%S'

state = 0
if BusinessServiceOrder.where(time_slot_id: @time_slot.id).any?
  state = 1
end
if BusinessServiceOrder.where(time_slot_id: @time_slot.id).joins(:order).where("orders.customer_id = #{current_user.role.id}").any?
  state = 2
end

json.id @time_slot.id
json.start @time_slot.datetime_from.strftime(date_format)
json.end @time_slot.datetime_to.strftime(date_format)

json.service_id @time_slot.business_service.service_id
json.title @time_slot.business_service.service.label

json.state state