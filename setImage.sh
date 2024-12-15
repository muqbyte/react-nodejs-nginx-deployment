#!/bin/bash

# Remove old Docker versions
sudo apt-get remove -y docker docker-engine docker.io

# Update package list
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Optional: Install Docker via Snap
sudo snap install docker

# Prompt for Docker images
read -p "Enter the Docker image for frontend: " frontend_image
read -p "Enter the Docker image for node-scheduler: " node_scheduler_image

# Validate input
if [ -z "$frontend_image" ] || [ -z "$node_scheduler_image" ]; then
  echo "Error: Both Docker images must be provided."
  exit 1
fi

# Path to docker-compose.yml (ensure proper expansion of ~ using $HOME)
DOCKER_COMPOSE_FILE="$HOME/reac-nodejs-deployment/nginxproxy/docker-compose.yml"

# Update the docker-compose.yml with the provided image names
sed -i.bak -e "s|FRONTEND_IMAGE_PLACEHOLDER|$frontend_image|g" -e "s|NODE_SCHEDULER_IMAGE_PLACEHOLDER|$node_scheduler_image|g" $DOCKER_COMPOSE_FILE

echo "Updated $DOCKER_COMPOSE_FILE with frontend image: $frontend_image and node-scheduler image: $node_scheduler_image"

# Navigate to nginxproxy folder and run docker-compose
cd "$HOME/reac-nodejs-deployment/nginxproxy"
sudo docker-compose up -d
