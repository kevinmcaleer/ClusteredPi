#!/bin/bash

echo "Stopping all Docker containers..."
sudo docker stop $(sudo docker ps -aq) 2>/dev/null

echo "Removing all Docker containers..."
sudo docker rm $(sudo docker ps -aq) 2>/dev/null

echo "Removing all Docker images..."
sudo docker rmi $(sudo docker images -q) 2>/dev/null

echo "Removing all Docker volumes..."
sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null

echo "Removing all Docker networks..."
sudo docker network rm $(sudo docker network ls -q) 2>/dev/null

echo "Uninstalling Docker and related packages..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

echo "Removing Docker directories..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf $HOME/.docker

echo "Removing Docker group..."
sudo groupdel docker 2>/dev/null

echo "Clearing any leftover dependencies..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "Docker has been completely uninstalled."
