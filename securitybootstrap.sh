#!/bin/bash

# Security Bootstrap Script
# This script configures security settings and installs security tools

set -e

echo "Starting Security Bootstrap..."

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi
}

# Configure firewall
configure_firewall() {
    echo "Configuring firewall..."
    
    # Install UFW (Uncomplicated Firewall)
    apt-get install -y ufw
    
    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing
    
    # Allow SSH
    ufw allow ssh
    
    # Enable firewall
    ufw --force enable
    
    echo "Firewall configured successfully"
}

# Install and configure fail2ban
install_fail2ban() {
    echo "Installing fail2ban..."
    
    apt-get install -y fail2ban
    
    # Create local configuration
    cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
EOF
    
    # Start and enable fail2ban
    systemctl start fail2ban
    systemctl enable fail2ban
    
    echo "fail2ban installed successfully"
}

# Secure SSH configuration
secure_ssh() {
    echo "Securing SSH configuration..."
    
    # Backup original config
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    # Update SSH configuration
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    
    # Restart SSH service
    systemctl restart sshd
    
    echo "SSH secured successfully"
}

# Install security tools
install_security_tools() {
    echo "Installing security tools..."
    
    apt-get install -y \
        rkhunter \
        chkrootkit \
        lynis \
        clamav \
        clamav-daemon
    
    # Update ClamAV signatures with error handling
    systemctl stop clamav-freshclam || true
    freshclam --quiet || echo "Warning: freshclam update failed, will retry on next scheduled update"
    systemctl start clamav-freshclam
    
    echo "Security tools installed successfully"
}

# Configure automatic security updates
configure_auto_updates() {
    echo "Configuring automatic security updates..."
    
    apt-get install -y unattended-upgrades apt-listchanges
    
    # Enable automatic updates non-interactively
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -plow unattended-upgrades
    
    echo "Automatic updates configured successfully"
}

# Main execution
main() {
    check_root
    
    configure_firewall
    install_fail2ban
    secure_ssh
    install_security_tools
    configure_auto_updates
    
    echo "Security bootstrap completed successfully!"
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
