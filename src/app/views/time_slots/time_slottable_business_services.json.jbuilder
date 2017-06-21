json.array! @business_services do |bs|
  json.id bs.id
  json.price bs.price
  json.enable_time_slots bs.enable_time_slots
  json.service_id bs.service_id
  json.service_label bs.service.label
  json.business_id bs.business_id
  json.business_name bs.business.name
end