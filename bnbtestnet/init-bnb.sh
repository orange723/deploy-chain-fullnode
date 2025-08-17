#!/bin/bash
set -e
# This script deploys a Binance Smart Chain full node using Docker.
# Update: 2025-8-17
# Usage: ./init-bnb.sh

# Create a directory for the Binance Smart Chain node data
DATA_DIR="./data"
mkdir -p "$DATA_DIR"