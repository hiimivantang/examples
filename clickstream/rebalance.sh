#!/bin/bash

docker run -it --net clickstream_default confluentinc/cp-server:5.5.0 bash -c "confluent-rebalancer execute --bootstrap-server kafka:29092 --metrics-bootstrap-server kafka:29092 --throttle 10000000 --verbose"
