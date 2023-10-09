-- Braz_schema.olist_orders_dataset has order_id and customer_id.
-- Braz_schema.olist_customers_dataset has customer city, state, zipcode, customer_id, and customer_zip_code_prefix.
-- Braz_schema.olist_order_items_dataset has order_id and price.  
-- Braz_schema.olist_geolocation_dataset has customer_zip_code_prefix.
SELECT
    o.order_id,
    order_purchase_timestamp,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
	geolocation_lat, 
    geolocation_lng,
    SUM(price) AS revenue
FROM Braz_schema.olist_orders_dataset o JOIN Braz_schema.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN Braz_schema.olist_order_items_dataset oi ON o.order_id = oi.order_id
LEFT JOIN Braz_schema.olist_geolocation_dataset g ON c.customer_zip_code_prefix = g. geolocation_zip_code_prefix
GROUP BY 1,2,3,4,5,6,7,8;
