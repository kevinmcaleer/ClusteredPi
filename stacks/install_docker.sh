#!/bin/bash

# Define list of packages to install
pkgstoinstall=(libffi-dev libssl-dev python3 python3-pip)

# Update package cache and install packages
sudo apt-get update
sudo apt-get install -y "${pkgstoinstall[@]}"

# Get the current user
CURRENT_USER=$(whoami)

# Define the path for the Docker install script
DOCKER_SCRIPT_PATH="/home/${CURRENT_USER}/get-docker.sh"

# Download Docker convenience script if it doesn't exist
if [ ! -f "$DOCKER_SCRIPT_PATH" ]; then
    curl -fsSL https://get.docker.com -o "$DOCKER_SCRIPT_PATH"
fi

# Install Docker if not already installed
if [ ! -f /usr/bin/docker ]; then
    sh "$DOCKER_SCRIPT_PATH"
fi

# Get the real user running the script
CURRENT_USER=${SUDO_USER:-$USER}

# Create the docker group
sudo groupadd docker

# Add the current user to the 'docker' group
sudo usermod -aG docker "$CURRENT_USER"

# Unmask the Docker service
sudo systemctl unmask docker

# Fix permissions for Docker socket
sudo chmod 666 /var/run/docker.sock

# Install docker-compose if it doesn't exist
if [ ! -f /usr/local/bin/docker-compose ]; then
    sudo apt install -y docker-compose
fi

# Start Docker service
sudo systemctl start docker

# Display message about group change (logout required)
echo "User '$CURRENT_USER' has been added to the 'docker' group. Please log out and log back in for changes to take effect."
