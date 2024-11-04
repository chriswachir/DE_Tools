#!/bin/bash

docker info


# Download Apache Flink Docker image
docker pull apache/flink:1.14.2

# Run Apache Flink container in detached mode
docker run -t -d --name jobmanager -p 8081:8081 apache/flink:1.14.2 jobmanager



docker ps

# Display container information
echo "Apache Flink container is running as a daemon."
echo "Container ID: $(docker ps -q --filter "name=flink-container")"
echo "Access Flink Web Dashboard at http://localhost:8081"


telnet localhost 8081


# Example: Run a Flink job using the Flink CLI (WordCount example)
docker exec -it flink-container ./bin/flink run -m localhost:8081 ./examples/streaming/WordCount.jar

# To stop and remove the container when done
 docker stop flink-container
 docker rm flink-container

# To check container logs
docker logs flink-container


# To run the script
./run_flink.sh

# Stop the existing Flink container
docker stop flink-container

# Remove the existing Flink container
docker rm flink-container

# Run a new Flink container with the desired name (jobmanager)
docker run -t -d --name jobmanager -p 8081:8081 apache/flink:1.14.2 jobmanager

# Get the IP address of the new Flink Job Manager
JM_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jobmanager)

echo "Flink Job Manager IP address: $JM_IP"
