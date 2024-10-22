#!/bin/bash

# Ensure we are being ran as root
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Remove any existing i2p repository file
rm -f /etc/yum.repos.d/i2p.repo

# Create a repository file for I2P
cat <<EOL > /etc/yum.repos.d/i2p.repo
[i2p]
name=I2P Repository
baseurl=https://i2p.net/i2p/download/centos7
enabled=1
gpgcheck=1
EOL

# Install EPEL repo if not installed (needed for I2P)
if ! rpm -q epel-release; then
    dnf install -y epel-release
fi

# Install dependencies
dnf install -y gnupg2 tor i2p

# Check if tor and i2p are installed
if ! command -v tor &> /dev/null || ! command -v i2prouter &> /dev/null; then
    echo "Tor and/or I2P failed to install."
    exit 1
fi

echo "Installation successful! Tor and I2P are now installed."

exit 0
