#!/bin/bash
# Fedora/RHEL Package Bootstrap Script

set -e
[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

dnf -y update

# Dev tools
dnf5 -y groupinstall "Development Tools"
dnf -y install git curl wget vim nano htop tmux screen net-tools openssh-server

# Languages
dnf -y install python3 python3-pip python3-virtualenv golang gcc-c++

# Node.js (Fedora module, then add TypeScript globally)
dnf -y module install nodejs:18
npm install -g typescript

# Terraform (from HashiCorp repo)
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf -y install terraform

# Containers & automation
dnf -y install podman docker-compose ansible

# Build tools
dnf -y install make cmake

# Utilities
dnf -y install unzip zip tar gzip bzip2 tree jq bc file rsync

dnf -y autoremove
dnf -y clean all

echo "Package bootstrap completed!"
