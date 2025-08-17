#!/bin/bash
set -e
# This script deploys a Scroll full node using Docker.
# Update: 2025-8-17
# Usage: ./init-scroll.sh

DATA_DIR="./data"
mkdir -p "$DATA_DIR"