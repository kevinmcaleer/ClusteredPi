#!/bin/bash

# Get the hostname of the machine to use as CRATE_NODE_NAME
CRATE_NODE_NAME=$(hostname)

# Define CRATE_DISCOVERY_SEED_HOSTS with specific IPs
CRATE_DISCOVERY_SEED_HOSTS="192.168.1.10:4300,192.168.2.1:4300"

# Write environment variables to .env file for Docker Compose
echo "CRATE_NODE_NAME=$CRATE_NODE_NAME" > .env
echo "CRATE_DISCOVERY_SEED_HOSTS=$CRATE_DISCOVERY_SEED_HOSTS" >> .env

echo "Starting CrateDB with node name: $CRATE_NODE_NAME"
echo "Discovery seed hosts: $CRATE_DISCOVERY_SEED_HOSTS"

# Start the docker-compose service
docker-compose up -d

echo "CrateDB node $CRATE_NODE_NAME started successfully and joined the cluster."
