#!/bin/bash -ex

export HADOOP_CLASSPATH=`hadoop classpath`
export FLINK=/usr/lib/flink
export GOOGLE_APPLICATION_CREDENTIALS=/home/binwu_maxwellx_altostrat_com/workspace/raycomoss/sql/forrest-test-project-333203-5565fd24df81.json
echo $GOOGLE_APPLICATION_CREDENTIALS

# https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.17.2/flink-sql-connector-kafka-1.17.2.jar
# https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.6.2/kafka-clients-3.6.2.jar
# https://repo1.maven.org/maven2/com/google/cloud/hosted/kafka/managed-kafka-auth-login-handler/1.0.2/managed-kafka-auth-login-handler-1.0.2.jar
# https://repo1.maven.org/maven2/org/apache/flink/flink-shaded-guava/31.1-jre-17.0/flink-shaded-guava-31.1-jre-17.0.jar
# https://repo1.maven.org/maven2/org/apache/flink/flink-shaded-guava/30.1.1-jre-16.2/flink-shaded-guava-30.1.1-jre-16.2.jar

# sudo $FLINK/bin/yarn-session.sh -nm flink-dataproc -d
sudo $FLINK/bin/sql-client.sh embedded -s yarn-session \
  -f ./events_gen.sql \
  -l $FLINK/lib/ \
  -j $FLINK/lib/flink-faker-0.5.3.jar
