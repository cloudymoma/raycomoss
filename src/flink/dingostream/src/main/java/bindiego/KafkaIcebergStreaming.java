/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package bindiego;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.sink.filesystem.rollingpolicies.DefaultRollingPolicy;
import org.apache.flink.streaming.api.windowing.assigners.TumblingEventTimeWindows;

import org.apache.flink.table.api.TableResult;
import org.apache.flink.table.api.EnvironmentSettings;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.serialization.SimpleStringSchema;

import org.apache.flink.connector.kafka.source.KafkaSource;
import org.apache.flink.connector.kafka.source.enumerator.initializer.OffsetsInitializer; 

/**
 * Consume data from Google Managed Kafka
 */

public class KafkaIcebergStreaming {
    private static final Logger LOG = LoggerFactory.getLogger(KafkaIcebergStreaming.class);

    public KafkaIcebergStreaming(final StreamExecutionEnvironment env, 
            final KafkaSource source) throws Exception {

        EnvironmentSettings settings = EnvironmentSettings.newInstance().inStreamingMode().build();
        StreamTableEnvironment tEnv = StreamTableEnvironment.create(env, settings);

        // Create a Kafka table with the structure of streaming data
        tEnv.executeSql(
            "create table kafka_table (" +
            "  user_id BIGINT, " +
            "  event_name STRING, " +
            "  `timestamp` TIMESTAMP(3), " +
            "  WATERMARK FOR `timestamp` AS `timestamp` - INTERVAL '5' SECOND" + 
            ") WITH (" +
            "  'connector' = 'kafka'," +
            "  'topic' = 'dingo-topic'," +
            "  'properties.bootstrap.servers' = 'bootstrap.dingo-kafka.us-central1.managedkafka.du-hast-mich.cloud.goog:9092'," +
            "  'format' = 'json'" +
            ")"
        );

        // Create Iceberg tables where you want to write the data
        tEnv.executeSql(
            "CREATE TABLE iceberg_table (" +
            "  user_id BIGINT, " +
            "  event_name STRING, " +
            "  `timestamp` TIMESTAMP(3)" +
            ") WITH (" +
            "  'connector' = 'iceberg'," +
            "  'catalog-type' = 'bigquery'," +
            "  'catalog-name' = 'du-hast-mich'," +
            "  'warehouse' = 'gs://dingoiceberg/warehouse/'," +
            "  'database-name' = 'du-hast-mich.raycomoss'," +
            "  'table-name' = 'fromkafka'" +
            ")"
        );

        // Insert data into the Iceberg table
        TableResult output = tEnv.executeSql("INSERT INTO iceberg_table SELECT * FROM kafka_table");
    }
}