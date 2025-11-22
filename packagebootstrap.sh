#!/bin/bash

# Package Bootstrap Script
# This script installs common packages and tools

set -e

echo "Starting Package Bootstrap..."

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi
}

# Update system packages
update_system() {
    echo "Updating system packages..."
    
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    
    echo "System updated successfully"
}

# Install essential development tools
install_dev_tools() {
    echo "Installing development tools..."
    
    apt-get install -y build-essential git curl wget vim nano \
        htop tmux screen net-tools openssh-server
    
    echo "Development tools installed successfully"
}

# Install programming languages
install_languages() {
    echo "Installing programming languages..."
    
    # Python
    apt-get install -y python3 python3-pip python3-venv
    
    # Node.js and npm
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
    
    # Java
    apt-get install -y default-jdk default-jre
    
    # Go
    apt-get install -y golang-go
    
    echo "Programming languages installed successfully"
}

# Install system utilities
install_utilities() {
    echo "Installing system utilities..."
    
    apt-get install -y unzip zip tar gzip bzip2 \
        tree jq bc file rsync
    
    echo "System utilities installed successfully"
}

# Clean up package cache
cleanup() {
    echo "Cleaning up..."
    
    apt-get autoremove -y
    apt-get autoclean -y
    
    echo "Cleanup completed"
}

# Main execution
main() {
    check_root
    
    update_system
    install_dev_tools
    install_languages
    install_utilities
    cleanup
    
    echo "Package bootstrap completed successfully!"
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
