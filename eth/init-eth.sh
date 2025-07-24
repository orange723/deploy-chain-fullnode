#!/bin/bash
set -e
# This script deploys an Ethereum full node using Docker Compose.
# It assumes you have Docker and Docker Compose installed.
# Usage: ./init-eth.sh

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Create a directory for the Ethereum node data
ETH_DATA_DIR="./eth_data"

# Create a directory for the Lighthouse beacon node data
LIGHTHOUSE_DATA_DIR="./lighthouse_data"

# Create the data directories if they do not exist
mkdir -p "$ETH_DATA_DIR"
mkdir -p "$LIGHTHOUSE_DATA_DIR"

# Init jwt secret
JWT_SECRET_FILE="./jwt.hex"
if [ ! -f "$JWT_SECRET_FILE" ]; then
    echo "Generating JWT secret..."
    echo $(openssl rand -hex 32) > "./jwt.hex"
else
    echo "JWT secret already exists."
fi
