#!/bin/bash

docker-compose exec ksqldb-cli bash -c "ksql http://ksqldb-server:8088"
