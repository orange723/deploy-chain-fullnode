#!/bin/bash
set -e
# This script deploys a Binance Smart Chain full node using Supervisord.
# Update: 2025-7-24
# Usage: ./init-bnb.sh

# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y
# Install necessary packages
sudo apt-get install -y wget jq curl supervisor

# Create a directory for the Binance Smart Chain node data
mkdir -p "/opt/bnb/{data,conf,bin,logs}"

# Get the latest release version
VERSION=$(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |jq -r '.tag_name')

# Download the latest release
wget $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)

# Rename the downloaded file
mv geth_linux "bsc-$VERSION"

# Replace supervisor configuration bsc binary
sed -i "s/bnb-binary/bsc-$VERSION/g" bnb.conf

# Move the binary to the bin directory
sudo mv "bsc-$VERSION" "/opt/bnb/bin/"

# Set permissions
sudo chmod +x "/opt/bnb/bin/bsc-$VERSION"

# Copy the configuration file
sudo cp config.toml "/opt/bnb/conf/"

# Copy the supervisor configuration file
sudo cp bnb.conf /etc/supervisor/conf.d/

# Reread the supervisor configuration
sudo supervisorctl reread

# After download snapshot, update the configuration
# sudo supervisorctl update