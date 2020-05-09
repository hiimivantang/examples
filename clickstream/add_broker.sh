#!/bin/bash

docker run -d \
    --net=clickstream_default \
    --name=kafka4 \
    -p 9095:9095 \
	-e KAFKA_BROKER_ID=4 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT \
    -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka4:29095,PLAINTEXT_HOST://localhost:9095 \
    -e KAFKA_METRIC_REPORTERS=io.confluent.metrics.reporter.ConfluentMetricsReporter \
    -e CONFLUENT_METRICS_REPORTER_BOOTSTRAP_SERVERS=kafka4:29095 \
    -e CONFLUENT_METRICS_REPORTER_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e CONFLUENT_METRICS_ENABLE='true' \
    -e CONFLUENT_SUPPORT_CUSTOMER_ID=anonymous \
    confluentinc/cp-server:5.5.0
