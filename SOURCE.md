# Data Source - Olist Brazilian Ecommerce

## Origin
- **Provider:** Olist Brazilian Ecommerce Operator
- **Published via:** Kaggle
- **Dataset URL:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- **Licence:** CC BY-NC-SA 4.0 Attribution-NonCommercial-ShareAlike 4.0 International
- **Download Date:** 2026-05-03
- **Kaggle dataset version:** 2.0

## About the Data

## Files Table

| File                                    | Rows    | Columns | Description                                      |
|-----------------------------------------|---------|---------|--------------------------------------------------|
| olist_orders_dataset.csv                | 99442   | 8       | One row per order, status and timestamps         |
| olist_customers_dataset.csv             | 99442   | 5       | Customer ID, city, state, zip                    |
| olist_order_items_dataset.csv           | 112651  | 7       | Line items — product, seller, price, freight     |
| olist_order_payments_dataset.csv        | 103887  | 5       | Payment type and installments per order          |
| olist_order_reviews_dataset.csv         | 104720  | 7       | Review score and text per order                  |
| olist_products_dataset.csv              | 32952   | 8       | Product ID, category, dimensions, weight         |
| olist_sellers_dataset.csv               | 3096    | 4       | Seller ID, city, state, zip                      |
| olist_geolocation_dataset.csv           | 1000164 | 5       | Zip prefix → lat/lng mapping                     |
| product_category_name_translation.csv   | 71      | 2       | Portuguese category names → English              |

## How the Files Relate

orders → customers          via customer_id
orders → order_items        via order_id
orders → order_payments     via order_id
orders → order_reviews      via order_id
order_items → products      via product_id
order_items → sellers       via seller_id
products → translation      via product_category_name
customers → geolocation     via customer_zip_code_prefix
sellers → geolocation       via seller_zip_code_prefix


## Reproducibility Notes
- Data folder is in .gitignore and is never committed
- To reproduce: download from the Kaggle URL above, unzip into data/raw/

## Known Issues or Caveats
- To be updated after initial data exploration.
