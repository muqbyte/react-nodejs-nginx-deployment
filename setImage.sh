#!/bin/bash

# Remove old Docker versions
sudo apt-get remove -y docker docker-engine docker.io

# Update package list
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Optional: Install Docker via Snap
sudo snap install docker

# Ensure createENV.sh is executable
chmod +x ./createENV.sh

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

# Path to docker-compose.yml files
DOCKER_COMPOSE_NGINX_FILE="/root/react-nodejs-nginx-deployment/nginxproxy/docker-compose.yml"
DOCKER_COMPOSE_REACT_FILE="/root/react-nodejs-nginx-deployment/reactnodejs/docker-compose.yml"

# Check if nginxproxy docker-compose.yml exists before modifying
if [ ! -f "$DOCKER_COMPOSE_NGINX_FILE" ]; then
  echo "Error: $DOCKER_COMPOSE_NGINX_FILE not found."
  exit 1
fi

# Check if reactnodejs docker-compose.yml exists before modifying
if [ ! -f "$DOCKER_COMPOSE_REACT_FILE" ]; then
  echo "Error: $DOCKER_COMPOSE_REACT_FILE not found."
  exit 1
fi

# Update the nginxproxy docker-compose.yml with the provided image names
sed -i.bak -e "s|FRONTEND_IMAGE_PLACEHOLDER|$frontend_image|g" $DOCKER_COMPOSE_NGINX_FILE
echo "Updated $DOCKER_COMPOSE_NGINX_FILE with frontend image: $frontend_image"

# Update the reactnodejs docker-compose.yml with the provided image names
sed -i.bak -e "s|FRONTEND_IMAGE_PLACEHOLDER|$frontend_image|g" -e "s|NODE_SCHEDULER_IMAGE_PLACEHOLDER|$node_scheduler_image|g" $DOCKER_COMPOSE_REACT_FILE
echo "Updated $DOCKER_COMPOSE_REACT_FILE with frontend image: $frontend_image and node-scheduler image: $node_scheduler_image"

# Navigate to nginxproxy folder and run docker-compose
cd /root/react-nodejs-nginx-deployment/nginxproxy || exit 1  # Exit if cd fails
echo "Running docker-compose in nginxproxy directory..."
sudo docker-compose up -d

# Navigate to reactnodejs folder and run docker-compose
cd /root/react-nodejs-nginx-deployment/reactnodejs || exit 1  # Exit if cd fails
echo "Running docker-compose in reactnodejs directory..."
sudo docker-compose up -d

echo "Docker containers started in both directories."
