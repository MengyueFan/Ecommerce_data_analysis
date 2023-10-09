-- Braz_schema.olist_orders_dataset has order_id and customer_id.
-- Braz_schema.olist_customers_dataset has customer city, state, zipcode, and customer_id.
-- Braz_schema.olist_order_items_dataset has order_id and price.  

SELECT
    o.order_id,
    order_purchase_timestamp,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    SUM(price)
FROM Braz_schema.olist_orders_dataset o JOIN Braz_schema.olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN Braz_schema.olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY 1,2,3,4,5,6;
