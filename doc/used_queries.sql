SELECT businesses.name, sum(business_services.price) FROM businesses
JOIN business_services ON business_services.business_id = businesses.id
JOIN business_service_orders ON business_services.id = business_service_orders.business_service_id
GROUP BY 1 ORDER BY 2 DESC LIMIT 5