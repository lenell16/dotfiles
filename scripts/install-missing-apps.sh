#!/usr/bin/env bash

# Script to download DMGs for missing applications
# Usage: ./install-missing-apps.sh

set -euo pipefail

DOWNLOADS_DIR="$HOME/Downloads"

# Function to check if app exists
app_exists() {
    local app_name="$1"
    [[ -d "/Applications/$app_name" ]] || [[ -d "/Applications/Nix Apps/$app_name" ]] || [[ -d "$HOME/Applications/$app_name" ]]
}

# Function to download DMG
download_dmg() {
    local app_name="$1"
    local download_url="$2"
    local filename="$3"
    
    if app_exists "$app_name"; then
        echo "✅ $app_name already installed"
        return 0
    fi
    
    echo "⬇️  Downloading $app_name..."
    curl -L "$download_url" -o "$DOWNLOADS_DIR/$filename"
    echo "📦 Downloaded $filename to $DOWNLOADS_DIR/"
    echo "👆 Please install manually from Downloads folder"
}

# Define apps to check/download
echo "🔍 Checking for missing applications..."

# Wispr Flow
download_dmg "Wispr Flow.app" "https://dl.wisprflow.ai/mac-apple/latest" "WisprFlow.dmg"

# Conar
download_dmg "Conar.app" "https://github.com/wannabespace/conar/releases/download/v0.17.4/Conar-Mac-arm64-0.17.4-Installer.dmg" "Conar-Mac-arm64-0.17.4-Installer.dmg"

# Add more apps here as needed
# download_dmg "SomeApp.app" "https://example.com/app.dmg" "SomeApp.dmg"

echo "✨ Done!"
