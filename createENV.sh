#!/bin/bash

# Prompt user for input (port numbers)
read -p "Enter DB_FRONTEND port number: " DB_FRONTEND
read -p "Enter DB_BACKEND port number: " DB_BACKEND  # Fix the variable name

# Create .env file
if ! touch .env; then
  echo "Failed to create .env file."
  exit 1
fi

# Add the required environment variables to the .env file
echo "DB_FRONTEND=$DB_FRONTEND" >> .env
echo "DB_BACKEND=$DB_BACKEND" >> .env  # Fix the variable name

# Make the .env file only readable by the current user
if ! chmod 600 .env; then
  echo "Failed to set permissions on .env file."
  exit 1
fi

echo "env file created successfully."
