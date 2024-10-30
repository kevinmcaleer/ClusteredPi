#!/bin/bash

# Get the hostname and the machine's primary IP address
export CRATE_NODE_NAME=$(hostname)
export MACHINE_IP=$(hostname -I | awk '{print $1}')  # Grabs the first IP address

# Define CRATE_DISCOVERY_SEED_HOSTS with all cluster IPs
export CRATE_DISCOVERY_SEED_HOSTS="192.168.1.10:4300,192.168.2.1:4300,192.168.2.2:4300"

# Write environment variables to .env file for Docker Compose
echo "CRATE_NODE_NAME=$CRATE_NODE_NAME" > .env
echo "CRATE_DISCOVERY_SEED_HOSTS=$CRATE_DISCOVERY_SEED_HOSTS" >> .env
echo "MACHINE_IP=$MACHINE_IP" >> .env

# Debug output
echo "Starting CrateDB with node name: $CRATE_NODE_NAME"
echo "Discovery seed hosts: $CRATE_DISCOVERY_SEED_HOSTS"
echo "Publishing host IP: $MACHINE_IP"

# Start the docker-compose service
docker-compose --env-file .env up -d
