#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <client-name>"
    exit 1
fi

CLIENT_NAME=$1
SERVER_PUBLIC_IP="ruanb.duckdns.org"
WG_DIR="/etc/wireguard"
SERVER_PUBLIC_KEY=$(sudo cat ${WG_DIR}/wg0.pub)

SCRIPT_DIR="$(dirname "$0")"
CLIENT_DIR="${SCRIPT_DIR}/clients"
CLIENT_TEMPLATE="${SCRIPT_DIR}/client-template.conf"

# Generate client keys
echo "Generating keys for ${CLIENT_NAME}..."
umask 077
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo "${CLIENT_PRIVATE_KEY}" | wg pubkey)

# Create client config
CLIENT_IP="10.0.0.$((RANDOM % 250 + 2))"
mkdir -p ${CLIENT_DIR}
cat "${CLIENT_TEMPLATE}" | sed \
    -e "s|CLIENT_PRIVATE_KEY|${CLIENT_PRIVATE_KEY}|" \
    -e "s|CLIENT_IP|${CLIENT_IP}|" \
    -e "s|SERVER_PUBLIC_KEY|${SERVER_PUBLIC_KEY}|" \
    -e "s|SERVER_PUBLIC_IP|${SERVER_PUBLIC_IP}|" > ${CLIENT_DIR}/${CLIENT_NAME}.conf

echo "Client configuration created at ${CLIENT_DIR}/${CLIENT_NAME}.conf"
echo "Client public key: ${CLIENT_PUBLIC_KEY}"
