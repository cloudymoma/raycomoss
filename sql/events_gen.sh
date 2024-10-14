#!/bin/bash -ex

export HADOOP_CLASSPATH=`hadoop classpath`
export FLINK=/usr/lib/flink

# https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.17.2/flink-sql-connector-kafka-1.17.2.jar
# https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.6.2/kafka-clients-3.6.2.jar
# https://repo1.maven.org/maven2/com/google/cloud/hosted/kafka/managed-kafka-auth-login-handler/1.0.2/managed-kafka-auth-login-handler-1.0.2.jar

sudo $FLINK/bin/sql-client.sh embedded -s yarn-session -f ./events_gen.sql -j $FLINK/lib/flink-faker-0.5.3.jar
