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