CREATE TABLE Braz_schema.olist_customers_dataset (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);
CREATE TABLE Braz_schema.olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(255),
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(255)
);
CREATE TABLE Braz_schema.olist_order_items_dataset (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date DATETIME,
    price INT,
    freight_value DOUBLE
);
CREATE TABLE Braz_schema.olist_order_payments_dataset (
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(255),
    payment_installments INT,
    payment_value DOUBLE
);
CREATE TABLE Braz_schema.olist_order_reviews_dataset (
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(255),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
CREATE TABLE Braz_schema.olist_orders_dataset (
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
CREATE TABLE Braz_schema.olist_products_dataset (
    product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
CREATE TABLE Braz_schema.olist_sellers_dataset (
    seller_id VARCHAR(255),
    seller_zip_code_prefix VARCHAR(255),
    seller_city VARCHAR(255),
    seller_state VARCHAR(255)
);
CREATE TABLE Braz_schema.product_category_name_translation (
    product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255)
);

/* Then use Terminal to import csv file

ls
cd /Users/mengyuefan/Desktop/archive
ls
mysql --local-infile=1 --show-warnings -h localhost -u root -p
SET GLOBAL local_infile = 1;
use Braz_schema;

LOAD DATA LOCAL INFILE 'product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

*/
