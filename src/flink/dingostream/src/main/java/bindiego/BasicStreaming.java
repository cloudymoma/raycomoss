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

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.serialization.SimpleStringSchema;

import org.apache.flink.connector.kafka.source.KafkaSource;
import org.apache.flink.connector.kafka.source.enumerator.initializer.OffsetsInitializer; 

/**
 * Consume data from Google Managed Kafka
 */

public class BasicStreaming {
    private static final Logger LOG = LoggerFactory.getLogger(BasicStreaming.class);

    public BasicStreaming(final StreamExecutionEnvironment env, 
            final KafkaSource source) throws Exception {
        /*
		 * Start with getting some data from the environment, like
		 * 	env.fromSequence(1, 10);
		 *
		 * then, transform the resulting DataStream<Long> using operations
		 * like
		 * 	.filter()
		 * 	.flatMap()
		 * 	.window()
		 * 	.process()
		 *
		 * and many more.
		 * Have a look at the programming guide:
		 *
		 * https://nightlies.apache.org/flink/flink-docs-stable/
		 *
		 */

        // Create a DataStream from the Kafka source
		DataStream<String> stream = env.fromSource(source, WatermarkStrategy.noWatermarks(), "Kafka Source");

		// Process the JSON data
		stream.map(json -> {
			// 1. Parse the JSON string
			// 2. Extract relevant fields
			// 3. Perform your data processing logic here
			
			// Example: Simply print the JSON string
			LOG.debug(json);
			return json; 
		});

        // Execute program, beginning computation.
        env.execute("Dingo Flink Java Skeleton");
    }
}