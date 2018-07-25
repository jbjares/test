#!/usr/bin/env bash

# Entrypoint for executing the integration test
# Will execute all files in the /tests directory
# that are prefixed with test_

set -e

die() {
echo $1
exit $2
}

# First we have to wait that all the services have become available
dockerize \
    -wait tcp://pht-service:8770 \
	  -wait tcp://neo4j:7474 \
    -wait tcp://registry:5000 \
    -timeout 30s > /dev/null 2>&1

# Push the print_hostname train to the registry
docker push localhost:5000/train_print_hostname

# Get the registered stations
curl -XGET -o /tmp/trains \
 http://pht-service:8770/train > /dev/null 2>&1

# Ensure that the services are part of the output
grep train_print_hostname /tmp/trains || die "train_print_hostname not in output" 1

# Print for control
cat /tmp/trains
