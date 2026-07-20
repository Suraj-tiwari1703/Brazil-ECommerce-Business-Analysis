-- ============================================
-- DROP TABLES (Child -> Parent)
-- ============================================

DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS sellers CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- ============================================
-- CUSTOMERS
-- ============================================

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix NUMERIC,
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- ============================================
-- SELLERS
-- ============================================

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix NUMERIC,
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

-- ============================================
-- PRODUCTS
-- ============================================

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_english VARCHAR(150),

    product_name_lenght NUMERIC,
    product_description_lenght NUMERIC,
    product_photos_qty NUMERIC,

    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

-- ============================================
-- ORDERS
-- ============================================

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,

    customer_id VARCHAR(50) NOT NULL,

    order_status VARCHAR(30),

    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ============================================
-- ORDER ITEMS
-- ============================================

CREATE TABLE order_items (

    order_id VARCHAR(50),
    order_item_id NUMERIC,

    product_id VARCHAR(50),
    seller_id VARCHAR(50),

    shipping_limit_date TIMESTAMP,

    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_orderitems_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_orderitems_sellers
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);

-- ============================================
-- PAYMENTS
-- ============================================

CREATE TABLE payments (

    order_id VARCHAR(50),

    payment_sequential NUMERIC,
    payment_type VARCHAR(30),
    payment_installments NUMERIC,
    payment_value NUMERIC(10,2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ============================================
-- REVIEWS
-- ============================================


COPY customers
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Customers.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);



COPY sellers
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Sellers.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);


COPY products
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Products.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);



COPY orders
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Orders.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);


COPY order_items
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Order_Items.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);



COPY payments
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Payments.csv'
WITH (
FORMAT csv,
HEADER true,
ENCODING 'UTF8'
);


COPY reviews
FROM 'D:/ShopSphere Enterprise Analytics/Dataset/Cleaned_Data/Reviews.csv'
WITH (
    FORMAT csv,
    HEADER true,
    ENCODING 'UTF8'
);



DROP TABLE reviews;

CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score NUMERIC,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    CONSTRAINT fk_reviews_orders
        FOREIGN KEY(order_id)
        REFERENCES orders(order_id)
);




SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews;


select * from customers;