#!/bin/bash

# Get the hostname of the machine to use as CRATE_NODE_NAME
export CRATE_NODE_NAME=$(hostname)

# Define CRATE_DISCOVERY_SEED_HOSTS with specific IPs
export CRATE_DISCOVERY_SEED_HOSTS="192.168.1.10:4300,192.168.2.1:4300,192.168.2.2:4300"

# Debug output
echo "CRATE_NODE_NAME is set to: $CRATE_NODE_NAME"
echo "CRATE_DISCOVERY_SEED_HOSTS is set to: $CRATE_DISCOVERY_SEED_HOSTS"

# Write environment variables to .env file for Docker Compose
echo "CRATE_NODE_NAME=$CRATE_NODE_NAME" > .env
echo "CRATE_DISCOVERY_SEED_HOSTS=$CRATE_DISCOVERY_SEED_HOSTS" >> .env

# Start the docker-compose service
docker-compose --env-file .env up -d
