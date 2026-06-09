import os

from psycopg import sql
from sqlalchemy import URL, create_engine
from dotenv import load_dotenv

load_dotenv()


url_object = URL.create(
    "postgresql+psycopg",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host="localhost",
    port=5433,
    database=os.getenv("DB_NAME"),
)

engine = create_engine(url_object)

tables = {
    "geolocation": (
        "olist_geolocation_dataset.csv",
        [
            "geolocation_zip_code_prefix",
            "geolocation_lat",
            "geolocation_lng",
            "geolocation_city",
            "geolocation_state",
        ],
    ),
    "customers": (
        "olist_customers_dataset.csv",
        [
            "customer_id",
            "customer_unique_id",
            "customer_zip_code_prefix",
            "customer_city",
            "customer_state",
        ],
    ),
    "sellers": (
        "olist_sellers_dataset.csv",
        ["seller_id", "seller_zip_code_prefix", "seller_city", "seller_state"],
    ),
    "products": (
        "olist_products_dataset.csv",
        [
            "product_id",
            "product_category_name",
            "product_name_lenght",
            "product_description_lenght",
            "product_photos_qty",
            "product_weight_g",
            "product_length_cm",
            "product_height_cm",
            "product_width_cm",
        ],
    ),
    "orders": (
        "olist_orders_dataset.csv",
        [
            "order_id",
            "customer_id",
            "order_status",
            "order_purchase_timestamp",
            "order_approved_at",
            "order_delivered_carrier_date",
            "order_delivered_customer_date",
            "order_estimated_delivery_date",
        ],
    ),
    "order_payment": (
        "olist_order_payments_dataset.csv",
        [
            "order_id",
            "payment_sequential",
            "payment_type",
            "payment_installments",
            "payment_value",
        ],
    ),
    "order_items": (
        "olist_order_items_dataset.csv",
        [
            "order_id",
            "order_item_id",
            "product_id",
            "seller_id",
            "shipping_limit_date",
            "price",
            "freight_value",
        ],
    ),
    "order_reviews": (
        "olist_order_reviews_dataset.csv",
        [
            "review_id",
            "order_id",
            "review_score",
            "review_comment_title",
            "review_comment_message",
            "review_creation_date",
            "review_answer_timestamp",
        ],
    ),
    "category_name_translation": (
        "product_category_name_translation.csv",
        ["product_category_name", "product_category_name_english"],
    ),
}

DATA_DIR = "data/raw"


def load_table(engine, table, csv_file, columns):
    print(f"Loading {table} from {csv_file}....")
    with engine.raw_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                sql.SQL("TRUNCATE TABLE {} CASCADE").format(sql.Identifier(table))
            )
            copy_sql = sql.SQL(
                "COPY {} ({}) FROM STDIN WITH (FORMAT csv, HEADER true)"
            ).format(
                sql.Identifier(table),
                sql.SQL(", ").join(sql.Identifier(column) for column in columns),
            )
            with cur.copy(copy_sql) as copy:
                with open(f"{DATA_DIR}/{csv_file}", "rb") as file:
                    while data := file.read(8192):
                        copy.write(data)
            cur.execute(
                sql.SQL("SELECT COUNT(*) FROM {}").format(sql.Identifier(table))
            )
            row_count = cur.fetchone()[0]
            print(f"    Loaded {row_count:,} rows into {table}")
        conn.commit()


if __name__ == "__main__":
    for table, (data, columns) in tables.items():
        load_table(engine=engine, table=table, csv_file=data, columns=columns)
