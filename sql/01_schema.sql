DROP TABLE IF EXISTS category_name_translation, order_reviews, order_payment, order_items, orders, products, sellers, customers, geolocation;

CREATE TABLE geolocation (
    id SERIAL,
    geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(50),
    geolocation_state VARCHAR(5),
    PRIMARY KEY (id)
);

CREATE TABLE customers (
    customer_id VARCHAR(40) NOT NULL,
    customer_unique_id VARCHAR(40) NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(40),
    customer_state VARCHAR(5),
    PRIMARY KEY (customer_id)
);

CREATE TABLE sellers (
    seller_id VARCHAR(40) NOT NULL,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(20),
    seller_state VARCHAR(5),
    PRIMARY KEY (seller_id)
);

CREATE TABLE products (
    product_id VARCHAR(40) NOT NULL,
    product_category_name VARCHAR(40),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    PRIMARY KEY (product_id)
);

CREATE TABLE orders (
    order_id VARCHAR(40) NOT NULL,
    customer_id VARCHAR(40) NOT NULL,
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    PRIMARY KEY(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_payment (
    order_id VARCHAR(40) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value NUMERIC(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_items (
    order_id VARCHAR(40) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(40) NOT NULL,
    seller_id VARCHAR(40) NOT NULL,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10, 2),
    freight_value NUMERIC(10, 2),
    PRIMARY KEY(order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(40) NOT NULL,
    order_id VARCHAR(40) NOT NULL,
    review_score INT,
    review_comment_title VARCHAR(100),
    review_comment_message VARCHAR,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE category_name_translation (
    product_category_name VARCHAR(40),
    product_category_name_english VARCHAR(50)
);
