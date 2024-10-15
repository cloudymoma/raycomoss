CREATE OR REPLACE TEMPORARY TABLE events_source (
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
  `event_type` STRING,
  WATERMARK FOR `created_at` AS `created_at` - INTERVAL '5' SECOND
)
WITH (
  'connector' = 'kafka',
  'topic' = 'pa-events',
  'properties.group.id' = 'paevents',
  'properties.bootstrap.servers' = 'bootstrap.pa-kafka.us-central1.managedkafka.forrest-test-project-333203.cloud.goog:9092',
  'value.format' = 'json',
  'properties.security.protocol' = 'SASL_SSL',
  'properties.sasl.mechanism' = 'OAUTHBEARER',
  'properties.sasl.login.callback.handler.class' = 'com.google.cloud.hosted.kafka.auth.GcpLoginCallbackHandler',
  'properties.sasl.jaas.config' = 'org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;',
  'scan.startup.mode' = 'earliest-offset'
)
;

INSERT INTO bqms.ecommerce.events
SELECT * FROM events_source
;
