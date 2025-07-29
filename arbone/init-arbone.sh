#!/bin/bash
set -e
# This script deploys a Arbone full node using Docker and Compose.
# Update: 2025-7-27
# Usage: ./init-arbone.sh

# Create a directory for the Arbone node data and snapdata
ARBONE_DIR="./data"
ARBONE_SNAPSHOT_DIR="./snapdata"
mkdir -p "$ARBONE_DIR"
mkdir -p "$ARBONE_SNAPSHOT_DIR"