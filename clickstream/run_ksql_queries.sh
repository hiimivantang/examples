#!/bin/bash

# Run the KSQL queries
docker-compose exec ksqldb-cli bash -c "ksql http://ksqldb-server:8088 <<EOF
run script '/scripts/statements.sql';
exit ;
EOF"

echo -e "\nSleeping 10 seconds\n"
sleep 10

