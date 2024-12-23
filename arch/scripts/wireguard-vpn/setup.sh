#!/bin/bash

set -e

# Variables
WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
SERVER_PRIVATE_KEY_FILE="${WG_DIR}/${WG_INTERFACE}.key"
SERVER_PUBLIC_KEY_FILE="${WG_DIR}/${WG_INTERFACE}.pub"
SERVER_PORT=51820
SERVER_IP="10.0.0.1"
CLIENT_TEMPLATE="./client-template.conf"

# Ensure WireGuard is installed
if ! command -v wg > /dev/null; then
    echo "Installing WireGuard..."
    sudo pacman -S --noconfirm wireguard-tools
fi

# Create WireGuard directory if it doesn't exist
sudo mkdir -p ${WG_DIR}
sudo chmod 700 ${WG_DIR}

# Generate server keys if not already present
if [[ ! -f ${SERVER_PRIVATE_KEY_FILE} ]]; then
    echo "Generating server keys..."
    umask 077
    wg genkey | sudo tee ${SERVER_PRIVATE_KEY_FILE} > /dev/null
    sudo cat ${SERVER_PRIVATE_KEY_FILE} | wg pubkey | sudo tee ${SERVER_PUBLIC_KEY_FILE} > /dev/null
fi

SERVER_PRIVATE_KEY=$(sudo cat ${SERVER_PRIVATE_KEY_FILE})
SERVER_PUBLIC_KEY=$(sudo cat ${SERVER_PUBLIC_KEY_FILE})

# Configure server
echo "Configuring WireGuard server..."
cat <<EOF | sudo tee ${WG_DIR}/${WG_INTERFACE}.conf
[Interface]
Address = ${SERVER_IP}/24
ListenPort = ${SERVER_PORT}
PrivateKey = ${SERVER_PRIVATE_KEY}

# Add clients below
EOF

# Enable and start WireGuard
sudo systemctl enable --now wg-quick@${WG_INTERFACE}

echo "WireGuard setup complete. Server public key:"
echo "${SERVER_PUBLIC_KEY}"

