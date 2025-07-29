#!/bin/bash
set -e
# This script deploys a Linea full node using Docker Compose.
# Update: 2025-7-27
# Usage: ./init-linea.sh

# Create a directory for the Linea node data
LINEA_DIR="./data"
mkdir -p "$LINEA_DIR"