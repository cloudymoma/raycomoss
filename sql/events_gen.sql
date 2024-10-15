CREATE OR REPLACE TEMPORARY TABLE events_sink (
  `id` BIGINT,
  `user_id` BIGINT,
  `sequence_number` BIGINT,
  `session_id` STRING,
  `created_at` TIMESTAMP(3),
  `ip_address` STRING,
  `city` STRING,
  `state` STRING,
  `postal_code` STRING,
  `browser` STRING,
  `traffic_source` STRING,
  `uri` STRING,
  `event_type` STRING
)
WITH (
  'connector' = 'kafka',
  'topic' = 'pa-events',
  'properties.bootstrap.servers' = 'bootstrap.pa-kafka.us-central1.managedkafka.forrest-test-project-333203.cloud.goog:9092',
  'value.format' = 'json',
  'properties.security.protocol' = 'SASL_SSL',
  'properties.sasl.mechanism' = 'OAUTHBEARER',
  'properties.sasl.login.callback.handler.class' = 'com.google.cloud.hosted.kafka.auth.GcpLoginCallbackHandler',
  'properties.sasl.jaas.config' = 'org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;'
)
;

CREATE OR REPLACE TEMPORARY TABLE events_gen
WITH (
  'connector' = 'faker',
  'rows-per-second' = '10',

  'fields.id.expression' = '#{number.numberBetween ''1'',''999999999''}',
  'fields.user_id.expression' = '#{number.numberBetween ''1'',''10000000''}',
  'fields.sequence_number.expression' = '#{number.numberBetween ''1'',''9999999999''}',
  'fields.session_id.expression' = '#{Internet.uuid}',
  'fields.created_at.expression' ='#{date.past ''90'',''DAYS''}',
  'fields.ip_address.expression' = '#{Internet.publicIpV4Address}',
  'fields.city.expression' = '#{Address.city}',
  'fields.state.expression' = '#{Address.state}',
  'fields.postal_code.expression' = '#{Address.zipCode}',
  'fields.browser.expression' = '#{Internet.userAgent}',
  'fields.traffic_source.expression' = '#{options.option ''(organic|direct|social|referral|email|paid)''}',
  'fields.uri.expression' = '#{Internet.url}',
  'fields.event_type.expression' = '#{options.option ''(page_view|add_cart|view_promotion|login|click|submit_review)''}'
)
LIKE events_sink (EXCLUDING ALL)
;

INSERT INTO events_sink
SELECT * FROM events_gen 
;

