#!/bin/bash
set -e
# This script deploys an Sepolia full node using Docker Compose.
# It assumes you have Docker and Docker Compose installed.
# Update: 2025-8-17
# Usage: ./init-sepolia.sh

# Create a directory for the Sepolia node data
ETH_DATA_DIR="./eth_data"

# Create a directory for the Lighthouse beacon node data
NIMBUS_DATA_DIR="./nimbus_data"

# Create the data directories
mkdir -p "$ETH_DATA_DIR"
mkdir -p "$NIMBUS_DATA_DIR"

# Init jwt secret
JWT_SECRET_FILE="./jwt.hex"
if [ ! -f "$JWT_SECRET_FILE" ]; then
    echo "Generating JWT secret..."
    echo $(openssl rand -hex 32) > "./jwt.hex"
else
    echo "JWT secret already exists."
fi