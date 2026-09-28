-- Question 1: Which product category drive the most revenue
SELECT
    SUM(price) AS total_revenue,
    product_category_name_english AS category
FROM order_items
INNER JOIN products
    ON order_items.product_id = products.product_id
INNER JOIN category_name_translation
    ON products.product_category_name = category_name_translation.product_category_name
GROUP BY product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Question 2: Which sellers have the worst delivery delay?
SELECT
    sellers.seller_id,
    sellers.seller_city,
    sellers.seller_state,
    ROUND (AVG (order_delivered_customer_date::DATE - order_estimated_delivery_date::DATE), 1) AS delay_days_avg,
    COUNT (*) AS total_late_orders
FROM order_items
INNER JOIN orders
    ON order_items.order_id = orders.order_id
INNER JOIN sellers
    ON order_items.seller_id = sellers.seller_id
WHERE
    order_status = 'delivered'
AND
    order_delivered_customer_date::DATE > CAST (order_estimated_delivery_date AS DATE)
GROUP BY 
    sellers.seller_id,
    sellers.seller_city,
    sellers.seller_state
HAVING COUNT(*) >= 10
ORDER BY delay_days_avg DESC
LIMIT 10;

-- Question 3: Does review score correlate with delivery time?
SELECT
    order_reviews.review_score,
    ROUND(AVG(orders.order_delivered_customer_date::DATE - orders.order_approved_at::DATE), 1) AS avg_delivery_days
FROM
    orders
INNER JOIN
    order_reviews
        ON orders.order_id = order_reviews.order_id
WHERE
    orders.order_status = 'delivered'
GROUP BY
    order_reviews.review_score
ORDER BY
    avg_delivery_days DESC;

-- Question 4: Where are high-value customers concentrated geographically?
SELECT
    customers.customer_state,
    SUM(order_payment.payment_value)  AS total_state_value
FROM
    orders
INNER JOIN
    order_payment
        ON order_payment.order_id = orders.order_id
INNER JOIN
    customers
        ON orders.customer_id = customers.customer_id
GROUP BY
    customers.customer_state
ORDER BY 
    total_state_value DESC;