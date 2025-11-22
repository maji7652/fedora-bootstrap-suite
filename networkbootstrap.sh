#!/bin/bash

# Network Bootstrap Script
# This script configures networking and installs network tools

set -e

echo "Starting Network Bootstrap..."

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi
}

# Install network tools
install_network_tools() {
    echo "Installing network tools..."
    
    apt-get update
    apt-get install -y \
        net-tools \
        dnsutils \
        traceroute \
        tcpdump \
        nmap \
        netcat \
        iptables \
        iptables-persistent \
        bridge-utils \
        ethtool \
        iftop \
        nethogs \
        speedtest-cli
    
    echo "Network tools installed successfully"
}

# Configure network settings
configure_network() {
    echo "Configuring network settings..."
    
    # Enable IP forwarding (only if not already set)
    grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    grep -q "^net.ipv6.conf.all.forwarding=1" /etc/sysctl.conf || echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
    
    # Apply settings
    sysctl -p
    
    echo "Network settings configured successfully"
}

# Install web server
install_web_server() {
    echo "Installing web server..."
    
    # Install Apache
    apt-get install -y apache2
    
    # Enable Apache modules
    a2enmod rewrite
    a2enmod ssl
    
    # Start and enable Apache
    systemctl start apache2
    systemctl enable apache2
    
    echo "Web server installed successfully"
}

# Install Nginx (alternative)
install_nginx() {
    echo "Installing Nginx..."
    
    apt-get install -y nginx
    
    # Start and enable Nginx
    systemctl start nginx
    systemctl enable nginx
    
    echo "Nginx installed successfully"
}

# Main execution
main() {
    check_root
    
    echo "Network bootstrap options:"
    echo "1) Install network tools only"
    echo "2) Install network tools and Apache"
    echo "3) Install network tools and Nginx"
    echo "4) Full network setup"
    
    read -r -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            install_network_tools
            ;;
        2)
            install_network_tools
            install_web_server
            ;;
        3)
            install_network_tools
            install_nginx
            ;;
        4)
            install_network_tools
            configure_network
            install_web_server
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
    
    echo "Network bootstrap completed successfully!"
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
