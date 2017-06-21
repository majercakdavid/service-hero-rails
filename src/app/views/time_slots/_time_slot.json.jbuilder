date_format = '%Y-%m-%dT%H:%M:%S'

json.id time_slot.id
json.start time_slot.datetime_from.strftime(date_format)
json.end time_slot.datetime_to.strftime(date_format)

json.service_id time_slot.business_service.service_id
json.service_name time_slot.business_service.service.label
json.business_id time_slot.business_service.service.business_id
json.business_id time_slot.business_service.service.business.name

json.color (if time_slot.business_service_order.nil? then "green" else "red" end)