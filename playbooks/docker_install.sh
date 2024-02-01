#!/bin/bash

# Elevate privileges
sudo su

# Define list of packages to install
pkgstoinstall=(libffi-dev libssl-dev python3 python3-pip)

# Update package cache and install packages
sudo apt-get update
sudo apt-get install -y "${pkgstoinstall[@]}"

# Download Docker convenience script if it doesn't exist
if [ ! -f /home/pi/get-docker.sh ]; then
    curl -fsSL https://get.docker.com -o /home/pi/get-docker.sh
fi

# Install Docker if not already installed
if [ ! -f /usr/bin/docker ]; then
    sh /home/pi/get-docker.sh
fi

# Add 'pi' user to the 'docker' group
sudo usermod -aG docker pi

# Unmask the Docker service
sudo systemctl unmask docker

# Fix permissions for Docker socket
sudo chmod 666 /var/run/docker.sock

# Install docker-compose if it doesn't exist
if [ ! -f /usr/local/bin/docker-compose ]; then
    sudo pip3 -v install docker-compose
fi

# Start Docker service
sudo systemctl start docker
