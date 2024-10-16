CREATE TABLE order_items (
  `order_id` BIGINT,
  `inventory_item_id` BIGINT,
  `status` STRING,
  `created_at` TIMESTAMP,
  `shipped_at` TIMESTAMP,
  `delivered_at` TIMESTAMP,
  `returned_at` TIMESTAMP,
  `sale_price` DECIMAL(10,2),
  PRIMARY KEY (order_id, inventory_item_id) NOT ENFORCED 
)
WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mysql://!MYSQL_IP:3306/ecommerce',
  'username'= 'ecommerce_user',
  'password'= '!MYSQL_USER_PASSWORD',
  'table-name' = 'order_items'
)
;

CREATE OR REPLACE TEMPORARY TABLE order_items_gen
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',

  'fields.order_id.expression' = '#{number.numberBetween ''1'',''10000000''}',
  'fields.inventory_item_id.expression' = '#{number.numberBetween ''1'',''10000''}',
  'fields.status.expression' = '#{options.option ''created'',''paid'',''shipped'',''delivered'',''cancelled'',''fulfiled'',''confirmed'',''returned''}',
  'fields.created_at.expression' ='#{date.past ''90'',''DAYS''}',
  'fields.shipped_at.expression' ='#{date.past ''3'',''DAYS''}',
  'fields.shipped_at.null-rate' ='0.5',
  'fields.delivered_at.expression' = '#{date.past ''3'',''DAYS''}',
  'fields.delivered_at.null-rate' ='0.5',
  'fields.returned_at.expression' = '#{date.past ''1'',''DAYS''}',
  'fields.returned_at.null-rate' ='0.9',
  'fields.sale_price.expression' = '#{number.randomDouble ''2'',''1'',''9999''}'
)
LIKE order_items (EXCLUDING ALL)
;

INSERT INTO order_items
SELECT * FROM order_items_gen
;

CREATE TABLE orders (
  `user_id` BIGINT,
  `delivery_address` STRING,
  `delivery_city` STRING,
  `delivery_country` STRING,
  `delivery_zipcode` STRING,
  `created_at` TIMESTAMP
)
WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mysql://!MYSQL_IP:3306/ecommerce',
  'username'= 'ecommerce_user',
  'password'= '!MYSQL_USER_PASSWORD',
  'table-name' = 'orders'
)
;

CREATE OR REPLACE TEMPORARY TABLE orders_gen
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',

  'fields.user_id.expression' = '#{number.numberBetween ''1'',''10000000''}',
  'fields.delivery_address.expression' = '#{Address.fullAddress}',
  'fields.delivery_city.expression' = '#{Address.cityName}',
  'fields.delivery_country.expression' = '#{Address.country}',
  'fields.delivery_zipcode.expression' = '#{Address.zipCode}',
  'fields.created_at.expression' ='#{date.past ''90'',''DAYS''}'
)
LIKE orders (EXCLUDING ALL)
;

INSERT INTO orders
SELECT * FROM orders_gen
;

CREATE TABLE payments (
  `user_id` BIGINT,
  `order_id` BIGINT,
  `amount` DECIMAL(20,2),
  `discount` DECIMAL(20,2),
  `status` STRING,
  `method` STRING, 
  `created_at` TIMESTAMP,
  PRIMARY KEY (user_id,order_id) NOT ENFORCED
)
WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mysql://!MYSQL_IP:3306/ecommerce',
  'username'= 'ecommerce_user',
  'password'= '!MYSQL_USER_PASSWORD',
  'table-name' = 'payments'
)
;

CREATE OR REPLACE TEMPORARY TABLE payments_gen
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',

  'fields.user_id.expression' = '#{number.numberBetween ''1'',''10000000''}',
  'fields.order_id.expression' = '#{number.numberBetween ''1'',''10000000''}',
  'fields.amount.expression' = '#{number.randomDouble ''2'',''1'',''9999''}',
  'fields.discount.expression' = '#{number.randomDouble ''2'',''1'',''99''}',
  'fields.status.expression' = '#{options.option ''created'',''confirmed'',''refunded'',''failed''}',
  'fields.method.expression' = '#{options.option ''visa'',''master'',''american_express'',''paypal'',''alipay'',''alipay_hk'',''wechat'',''wechat_hk'',''payme'',''octopus'',''china_union''}',
  'fields.created_at.expression' ='#{date.past ''90'',''DAYS''}'
)
LIKE payments (EXCLUDING ALL)
;

INSERT INTO payments
SELECT * FROM payments_gen
;