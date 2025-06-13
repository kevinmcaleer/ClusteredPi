#!/bin/bash

# Loop through all running services
services=$(docker service ls --format '{{.Name}}')

for service in $services; do
    echo "Rebalancing service: $service"
    docker service update --force "$service"
done
