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

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.apache.flink.api.java.utils.ParameterTool;

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
 * Skeleton for a Flink DataStream Job.
 *
 * <p>For a tutorial how to write a Flink application, check the
 * tutorials and examples on the <a href="https://flink.apache.org">Flink Website</a>.
 *
 * <p>To package your application into a JAR file for execution, run
 * 'mvn clean package' on the command line.
 *
 * <p>If you change the name of the main class (with the public static void main(String[] args))
 * method, change the respective entry in the POM.xml file (simply search for 'mainClass').
 */
public class DataStreamJob {

	private static final Logger LOG = LoggerFactory.getLogger(DataStreamJob.class);

	public static void main(String[] args) throws Exception {
		// parse the parameters
        final ParameterTool params = ParameterTool.fromArgs(args);
        final long windowSize = params.getLong("windowSize", 2000);
        final long rate = params.getLong("rate", 3L);
        final boolean fileOutput = params.has("output");

		// Sets up the execution environment, which is the main entry point
		// to building Flink applications.
		final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

		// make parameters available in the web interface
        env.getConfig().setGlobalJobParameters(params);

		/*
		 * Here, you can start creating your execution plan for Flink.
		 *
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

		 // Kafka connector: https://nightlies.apache.org/flink/flink-docs-release-1.19/docs/connectors/datastream/kafka/
		 // Create a Kafka source
		 KafkaSource<String> source = KafkaSource.<String>builder()
			.setBootstrapServers("bootstrap.dingo-kafka.us-central1.managedkafka.du-hast-mich.cloud.goog:9092") // Replace with your Kafka brokers
			.setTopics("dingo-topic")  // Replace with your Kafka topic name
			//.setGroupId("my-consumer-group") // Replace with your consumer group ID
			.setStartingOffsets(OffsetsInitializer.earliest()) // Read from the beginning
			.setValueOnlyDeserializer(new SimpleStringSchema())
			.setProperty("partition.discovery.interval.ms", "10000") // discover new partitions per 10 seconds
			.build();

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
