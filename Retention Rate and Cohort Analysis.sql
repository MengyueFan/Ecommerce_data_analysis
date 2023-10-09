
-- *********************************************************** Pre cohort Analysis: overall repurchase rate (retention rate) *********************************************************** 
/* NOTE: REPURCHASE RATE in this project is the RETENTION RATE. Because we lack of users' visits data. */

-- First Check two relevant tables: Braz_schema.olist_customers_dataset and Braz_schema.olist_orders_dataset

SELECT customer_id, count(customer_id) FROM Braz_schema.olist_orders_dataset
GROUP BY customer_id
ORDER BY COUNT(*) DESC; -- The customer_id in Braz_schema.olist_orders_dataset is unique.

SELECT customer_id, count(customer_id) FROM Braz_schema.olist_customers_dataset
GROUP BY customer_id
ORDER BY COUNT(*) DESC; -- The customer_id in BBraz_schema.olist_customers_dataset is unique as well.

-- Then Question: There are customer_id and customer_unique_id. What is the connection/difference between them?

SELECT customer_unique_id, count(customer_unique_id) FROM Braz_schema.olist_customers_dataset
GROUP BY customer_unique_id
ORDER BY COUNT(*) DESC; -- The customer_unique_id in Braz_schema.olist_customers_dataset can be appearred several different times because customers repurchased.

-- Answer to above question: We can conclude that 
-- customer_id in Braz_schema.olist_customers_dataset IS customer_id in Braz_schema.olist_orders_dataset;
-- One customer_unique_id can have several different customer_id.

SELECT customer_unique_id, count(*) FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id; -- This gives a table that counts the number of purchases that each customer made. It has two columns: unique ID and number of purchase.

SELECT COUNT(*) FROM (
SELECT customer_unique_id, count(*) FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id) count_customer; -- Get the total number of customers who appearred in Braz_schema.olist_orders_dataset table: 96096. 

SELECT COUNT(customer_unique_id)
FROM (
SELECT customer_unique_id, count(*) AS order_times FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id) count_repurchased WHERE order_times > 1; -- Get the number of customers who made purchases more than once: 2297.

-- Finally, Put everything together

WITH count_customer AS (
SELECT COUNT(*) AS customer_count FROM
(
SELECT customer_unique_id, count(*) AS order_times FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o ON c.customer_id = o.customer_id
group by customer_unique_id) count_customer),

count_repurchased AS (
SELECT COUNT(customer_unique_id) AS repurchased_customer_count
FROM (
SELECT customer_unique_id, count(*) AS order_times FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id) count_repurchased WHERE order_times > 1)

SELECT ROUND((count_repurchased.repurchased_customer_count * 100 / count_customer.customer_count), 2) AS percentage_repurchased
FROM count_customer, count_repurchased; -- REPURCHASE RATE is 3.12

-- RETNTION RATE (i.e., REPURCHASE RATE) is 3.12.

-- *************************************************************************** Cohort Analysis ****************************************************************************
-- Step 1: insert unqiue IDs of cutomers into Braz_schema.olist_orders_dataset table 

SELECT customer_unique_id, o.*
FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o on c.customer_id = o.customer_id;

-- Step 2: find the unqiue ID's first purchase time

-- Step 2.1: Add the unqiue ID column into Braz_schema.olist_orders_dataset, save the new table as customer_order.

WITH customer_order AS (
SELECT customer_unique_id, o.*
FROM Braz_schema.olist_customers_dataset c
INNER JOIN Braz_schema.olist_orders_dataset o on c.customer_id = o.customer_id
),

-- Step 2.2: In table customer_order, find the unqiue ID's first purchase, save each customer's first purchase time as cohort_timestamp. 
-- The new table cohort_time consists of customer_unique_id and cohort_timestamp.

cohort_time AS(
SELECT customer_unique_id, MIN(order_purchase_timestamp) AS cohort_timestamp
FROM customer_order
GROUP BY customer_unique_id
),

-- Step 2.3: Get the columns of o.order_id, c.customer_unique_id, o.order_purchase_timestamp, cm.cohort_timestamp, order_year, order_month, cohort_year, and cohort_month
-- Save it as new table cohort_order_year_month
-- Here o is Braz_schema.olist_orders_dataset,
-- c is Braz_schema.olist_customers_dataset, and 
-- cm is cohort_timestamp we created in Step 2.2.

cohort_order_year_month AS (
SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp, cm.cohort_timestamp, 
YEAR(order_purchase_timestamp) AS order_year, MONTH(order_purchase_timestamp) AS order_month, 
YEAR(cohort_timestamp) AS cohort_year, MONTH(cohort_timestamp) AS cohort_month
FROM Braz_schema.olist_orders_dataset o
JOIN Braz_schema.olist_customers_dataset c ON c.customer_id = o.customer_id
JOIN cohort_time cm ON c.customer_unique_id = cm.customer_unique_id
WHERE o.order_status LIKE 'delivered'
)

-- Step 2.4: From new table cohort_order_year_month, 
-- Get the columns of order_id, customer_unique_id, cohort_timestamp, 
-- Use the order_year, order_month, cohort_year, and cohort_month to calculate the cohort index, save it as the new column cohort_index.

SELECT order_id, customer_unique_id, cohort_timestamp, ((order_year - cohort_year)*12 + (order_month - cohort_month)) AS conhort_index
FROM cohort_order_year_month;

-- Step 3: Export the final table that consists of order_id, customer_unique_id, cohort_timestamp, and conhort_index.






