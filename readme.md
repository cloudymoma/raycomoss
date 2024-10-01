# OSS Streaming data pipeline on GCP

Open source version of [raycom](https://github.com/cloudymoma/raycom). Replaced
the [Pub/Sub](https://cloud.google.com/pubsub/docs/overview) with
[Kafka](https://cloud.google.com/products/managed-service-for-apache-kafka), and
[Dataflow](https://cloud.google.com/products/dataflow) with
[Flink](https://cloud.google.com/managed-flink/docs/overview)

## Maven

Use `maven` to generate a skeleton flink project

```shell
mvn archetype:generate \
    -DarchetypeGroupId=org.apache.flink \
    -DarchetypeArtifactId=flink-quickstart-java \
    -DarchetypeVersion=1.20.0
```