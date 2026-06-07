#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "🛠️ Starting Project Ecosystem Setup Script"
echo "=========================================="

# Detect Operating System
OS_TYPE="$(uname -s)"

# Function to check and install Docker
install_docker() {
    if command -v docker &> /dev/null; then
        echo "✅ Docker is already installed: $(docker --version)"
    else
        echo "❌ Docker not found. Commencing automated installation..."
        
        if [ "$OS_TYPE" = "Linux" ]; then
            echo "🐧 Linux detected. Fetching official Docker installation package..."
            # Download and run official automated convenience script
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            rm get-docker.sh
            
            echo "🔄 Activating and enabling Docker daemon system services..."
            sudo systemctl start docker
            sudo systemctl enable docker
            
            echo "👤 Granting current user permissions to run Docker without sudo..."
            sudo usermod -aG docker $USER
            echo "👉 NOTE: On Linux, you may need to log out and log back in for user group changes to apply!"

        elif [ "$OS_TYPE" = "Darwin" ]; then
            echo "🍏 macOS detected. Checking for Homebrew..."
            if ! command -v brew &> /dev/null; then
                echo "❌ Homebrew is required for automated macOS installations."
                echo "Please install it from https://brew.sh/ or install Docker Desktop manually."
                exit 1
            fi
            echo "📦 Installing Docker Desktop via Homebrew Cask..."
            brew install --cask docker
            echo "🚀 Launching Docker Desktop application..."
            open /Applications/Docker.app
            echo "👉 NOTE: Please look at your macOS menu bar and complete the Docker UI setup wizard if prompted."
        else
            echo "🚫 Unsupported Operating System environment."
            exit 1
        fi
    fi
}

# Run the installation subroutine
install_docker

echo "=========================================="
echo "🎉 Setup complete! Your local system is ready."
echo "👉 Open this folder in VS Code and select 'Reopen in Container'."
echo "=========================================="