#!/bin/bash

set -e

# Variables
WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
SERVER_PRIVATE_KEY_FILE="${WG_DIR}/${WG_INTERFACE}.key"
SERVER_PUBLIC_KEY_FILE="${WG_DIR}/${WG_INTERFACE}.pub"
SERVER_PORT=51820
SERVER_IP="10.0.0.1"
CLIENT_DIR="./scripts/wireguard-vpn/clients"

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

# Regenerate WireGuard config
echo "Regenerating WireGuard server config..."

# Start the server config with the general settings
cat <<EOF | sudo tee ${WG_DIR}/${WG_INTERFACE}.conf
[Interface]
Address = ${SERVER_IP}/24
ListenPort = ${SERVER_PORT}
PrivateKey = ${SERVER_PRIVATE_KEY}

# Add clients below
EOF

# Loop through the clients directory and extract the public keys and IPs
for CLIENT_CONF in ${CLIENT_DIR}/*.conf; do
    CLIENT_NAME=$(basename "${CLIENT_CONF}" .conf)
    CLIENT_PUBLIC_KEY=$(grep "PublicKey" "${CLIENT_CONF}" | cut -d' ' -f3)
    CLIENT_IP=$(grep "Address" "${CLIENT_CONF}" | cut -d' ' -f3)

    # Append the client to the server config
    echo "Adding ${CLIENT_NAME} to server configuration..."
    cat <<EOF | sudo tee -a ${WG_DIR}/${WG_INTERFACE}.conf
[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = ${CLIENT_IP}
EOF
done

# Restart WireGuard to apply new configurations
sudo systemctl restart wg-quick@${WG_INTERFACE}

echo "WireGuard config updated with all clients."
