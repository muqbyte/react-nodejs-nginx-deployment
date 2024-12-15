#!/bin/bash

# Remove old Docker versions
sudo apt-get remove -y docker docker-engine docker.io

# Update package list
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Optional: Install Docker via Snap
sudo snap install docker

# Run createENV.sh script to generate .env file
echo "Running createENV.sh to generate .env file..."
./createENV.sh

# Check if .env file exists after running createENV.sh
if [ ! -f ".env" ]; then
  echo "Error: .env file not created."
  exit 1
fi

# Prompt for Docker images
read -p "Enter the Docker image for frontend: " frontend_image
read -p "Enter the Docker image for node-scheduler: " node_scheduler_image

# Validate input
if [ -z "$frontend_image" ] || [ -z "$node_scheduler_image" ]; then
  echo "Error: Both Docker images must be provided."
  exit 1
fi

# Path to docker-compose.yml (use /root explicitly)
DOCKER_COMPOSE_FILE="/root/reac-nodejs-deployment/nginxproxy/docker-compose.yml"

# Check if docker-compose.yml exists before modifying
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
  echo "Error: $DOCKER_COMPOSE_FILE not found."
  exit 1
fi

# Update the docker-compose.yml with the provided image names
sed -i.bak -e "s|FRONTEND_IMAGE_PLACEHOLDER|$frontend_image|g" -e "s|NODE_SCHEDULER_IMAGE_PLACEHOLDER|$node_scheduler_image|g" $DOCKER_COMPOSE_FILE

echo "Updated $DOCKER_COMPOSE_FILE with frontend image: $frontend_image and node-scheduler image: $node_scheduler_image"

# Navigate to nginxproxy folder and run docker-compose
cd /root/reac-nodejs-deployment/nginxproxy || exit 1  # Exit if cd fails
sudo docker-compose up -d
