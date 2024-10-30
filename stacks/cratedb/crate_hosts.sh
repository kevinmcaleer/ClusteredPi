#!/bin/bash

# Get the hostname of the machine to use as CRATE_NODE_NAME
CRATE_NODE_NAME=$(hostname)

# Prompt for CRATE_DISCOVERY_SEED_HOSTS
echo "Enter the discovery seed hosts (e.g., 192.168.1.10:4300,192.168.1.11:4300):"

CRATE_DISCOVERY_SEED_HOSTS="192.168.1.10:4300,192.168.2.1:4300"
# read -p "CRATE_DISCOVERY_SEED_HOSTS: " CRATE_DISCOVERY_SEED_HOSTS

# Export the environment variables for docker-compose
export CRATE_NODE_NAME
export CRATE_DISCOVERY_SEED_HOSTS

echo "Starting CrateDB with node name: $CRATE_NODE_NAME"
echo "Discovery seed hosts: $CRATE_DISCOVERY_SEED_HOSTS"

# Start the docker-compose service
docker-compose up -d

echo "CrateDB node $CRATE_NODE_NAME started successfully and joined the cluster."
