json.array! @time_slots do |time_slot|
  #date_format = event.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  #json.allDay event.all_day_event? ? true : false
  date_format = '%Y-%m-%dT%H:%M:%S'
  state = 0
  if !time_slot.business_service_order.nil?
    state = 1
  end
  if BusinessServiceOrder.where(time_slot_id: time_slot.id).joins(:order).where("orders.customer_id = #{current_user.role.id}").any?
    state = 2
  end

  json.id time_slot.id
  json.title time_slot.business_service.service.label
  json.start time_slot.datetime_from.strftime(date_format)
  json.end time_slot.datetime_to.strftime(date_format)
  json.state state
  #json.update_url event_path(event, method: :patch)
  #json.edit_url edit_event_path(event)
end