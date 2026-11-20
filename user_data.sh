#!/bin/bash

set -e

# Update packages
dnf update -y

# Install wget and unzip
dnf install -y wget unzip

# Create installation directory
mkdir -p /opt/myapp

# Navigate to installation directory
cd /opt/myapp

# Download ZIP file
wget -O fake_service.zip "https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip"

# Extract ZIP file
unzip -o fake_service.zip

# Make binary executable
sudo chmod +x /opt/myapp/fake-service

# Remove ZIP file
rm -f fake_service.zip

echo "Binary installation completed!"

cat > /home/ec2-user/.ssh/account-key.pem <<'PRIVATE_KEY'
${bastion_private_key}
PRIVATE_KEY

echo "Private key written to /home/ec2-user/.ssh/account-key.pem"
