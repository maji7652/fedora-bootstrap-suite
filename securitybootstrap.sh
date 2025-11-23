#!/bin/bash
# Security Bootstrap Script (Fedora/RHEL concise)

set -e
[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

dnf -y update

echo "security script"

# Firewall
dnf -y install firewalld
systemctl enable --now firewalld
firewall-cmd --set-default-zone=drop
firewall-cmd --permanent --zone=drop --add-service=ssh
firewall-cmd --reload

# Fail2ban
dnf -y install fail2ban
cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = /var/log/secure
EOF
systemctl enable --now fail2ban

# Secure SSH
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Security tools
dnf -y install rkhunter chkrootkit lynis clamav clamav-update
systemctl stop clamav-freshclam || true
freshclam --quiet || echo "Warning: freshclam update failed"
systemctl start clamav-freshclam || true

# Auto updates
dnf -y install dnf-automatic
systemctl enable --now dnf-automatic.timer

echo "Security bootstrap completed!"
