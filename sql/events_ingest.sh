#!/bin/bash -ex

export HADOOP_CLASSPATH=`hadoop classpath`
export FLINK=/usr/lib/flink
export GOOGLE_APPLICATION_CREDENTIALS=/home/binwu_maxwellx_altostrat_com/workspace/raycomoss/sql/forrest-test-project-333203-5565fd24df81.json
echo $GOOGLE_APPLICATION_CREDENTIALS

# https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kafka/3.1.0-1.17/flink-connector-kafka-3.1.0-1.17.jar

# sudo $FLINK/bin/yarn-session.sh -nm flink-dataproc -d
sudo $FLINK/bin/sql-client.sh embedded -s yarn-session \
  -i ./catalog.sql \
  -f ./kafka2iceberg_events.sql \
  -j $FLINK/lib/demo-examples-gcp-1.0.0-shaded.jar \
  -j $FLINK/lib/iceberg-bigquery-catalog-1.5.2-0.1.0.jar \
  -l $FLINK/lib/ 
