USE bqms.ecommerce;

CREATE OR REPLACE TEMPORARY TABLE order_items_source (
  `id` BIGINT,
  `order_id` BIGINT,
  `inventory_item_id` BIGINT,
  `status` STRING,
  `created_at` TIMESTAMP,
  `shipped_at` TIMESTAMP,
  `delivered_at` TIMESTAMP,
  `returned_at` TIMESTAMP,
  `sale_price` DOUBLE,
  PRIMARY KEY (order_id, inventory_item_id) NOT ENFORCED 
)
WITH (
  'connector' = 'mysql-cdc',
  'hostname' = '!MYSQL_IP',
  'port' = '3306',
  'username' = 'ecommerce_user',
  'password' = '!MYSQL_USER_PASSWORD',
  'database-name' = 'ecommerce',
  'table-name' = 'order_items'
)
;

INSERT INTO order_items
SELECT * FROM order_items_source
;

CREATE OR REPLACE TEMPORARY TABLE orders_source (
  `id` BIGINT,
  `user_id` BIGINT,
  `delivery_address` STRING,
  `delivery_city` STRING,
  `delivery_country` STRING,
  `delivery_zipcode` STRING,
  `created_at` TIMESTAMP,
  PRIMARY KEY (id) NOT ENFORCED
)
WITH (
  'connector' = 'mysql-cdc',
  'hostname' = '!MYSQL_IP',
  'port' = '3306',
  'username' = 'ecommerce_user',
  'password' = '!MYSQL_USER_PASSWORD',
  'database-name' = 'ecommerce',
  'table-name' = 'orders'
)
;

INSERT INTO orders
SELECT * FROM orders_source
;

CREATE OR REPLACE TEMPORARY TABLE payments_source (
  `id` BIGINT,
  `user_id` BIGINT,
  `order_id` BIGINT,
  `amount` DECIMAL(20,2),
  `discount` DECIMAL(20,2),
  `status` STRING,
  `method` STRING, 
  `created_at` TIMESTAMP,
  PRIMARY KEY (id) NOT ENFORCED
)
WITH (
  'connector' = 'mysql-cdc',
  'hostname' = '!MYSQL_IP',
  'port' = '3306',
  'username' = 'ecommerce_user',
  'password' = '!MYSQL_USER_PASSWORD',
  'database-name' = 'ecommerce',
  'table-name' = 'payments'
)
;

INSERT INTO payments
SELECT * FROM payments_source
;