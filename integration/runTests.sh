#!/bin/bash

set -e

determineSocketPath() {

  if [ -S /run/docker.sock ]; then
    echo "/run/docker.sock"
  elif [ -S /var/run/docker.sock ]; then
    echo "/var/run/docker.sock"
  fi
}

setupInsecureRegistry(){

  # Configure Docker
  echo '{  "insecure-registries" : ["registry:5000", "localhost:5000"] }' > /tmp/daemon.json
  sudo mkdir -p /etc/docker
  sudo rm -f /etc/docker/daemon.json
  sudo mv /tmp/daemon.json  /etc/docker/daemon.json
}


restartDocker() {

   sudo systemctl restart docker || true > /dev/null 2>&1
   sudo service docker restart || true > /dev/null 2>&1
}
setupInsecureRegistry
restartDocker

# Set test variables
export DOCKER_SOCKET="$(determineSocketPath)"


# update the submodules
git submodule init  > /dev/null 2>&1
git submodule update --remote --recursive  > /dev/null 2>&1

# Build the Docker images for testing
cd pht-service
make build
cd ..

cd pht-station-simple
make build
cd ..

./pht-trains/buildTrains.sh

echo "######################################    BUILD COMPLETED - NOW RUNNING INTEGRATION TESTS ############################"

for test in ./test*; do

  # Fire up docker-compose and attach to the test serive
  cd "${test}"
    echo "Running test: ${test}"
    docker-compose build --no-cache > /dev/null 2>&1
    docker-compose up --exit-code-from test-service
    echo "Success"
  cd ..
done
