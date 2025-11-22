#!/bin/bash

# Network Bootstrap Script
# This script configures networking and installs network tools


set -e
[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

install_network_tools() {
    apt-get update
    apt-get install -y \
        net-tools dnsutils traceroute tcpdump nmap netcat iptables iptables-persistent \
        bridge-utils ethtool iftop nethogs speedtest-cli \
        curl wget mtr whois arp nmcli iwconfig tracepath hping3 socat ss
}

# this enables port forwarding for ipv4 and ipv6
# configure_network() {
#     grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
#     grep -q "^net.ipv6.conf.all.forwarding=1" /etc/sysctl.conf || echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
#     sysctl -p
# }

install_apache() {
    apt-get install -y apache2
    a2enmod rewrite ssl
    systemctl enable --now apache2
}

install_nginx() {
    apt-get install -y nginx
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
