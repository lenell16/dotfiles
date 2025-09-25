#!/usr/bin/env bash

# List all App Store applications with their IDs
# Usage: ./list-appstore-apps.sh

echo "App Store applications installed on this system:"
echo "================================================"
echo

# Use mas to list all installed App Store apps
# Format: ID  Name (Version)
mas list | sort -k2

echo
echo "To install any of these apps on another system, use:"
echo "mas install <ID>"
