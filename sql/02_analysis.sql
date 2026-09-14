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