#!/bin/bash
# Network Bootstrap Script (Fedora/RHEL version)
# This script configures networking and installs network tools

set -e
[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

echo "network script"

install_network_tools() {
    dnf -y update
    dnf -y install \
        net-tools bind-utils traceroute tcpdump nmap nmap-ncat iptables \
        bridge-utils ethtool iftop nethogs speedtest-cli \
        curl wget mtr whois iproute NetworkManager-wifi wireless-tools iputils hping3 socat iproute
}

# this enables port forwarding for ipv4 and ipv6
# configure_network() {
#     grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
#     grep -q "^net.ipv6.conf.all.forwarding=1" /etc/sysctl.conf || echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
#     sysctl -p
# }

install_apache() {
    dnf -y install httpd
    systemctl enable --now httpd
}

install_nginx() {
    dnf -y install nginx
    systemctl enable --now nginx
}

main() {
    install_network_tools
    # configure_network   # disabled
    install_apache
    install_nginx
    echo "Network bootstrap completed successfully!"
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@"
