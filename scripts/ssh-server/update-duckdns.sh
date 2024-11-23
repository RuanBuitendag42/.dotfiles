#!/bin/bash

# DuckDNS update script
TOKEN="cf36bd09-a4ec-4816-914e-b05bcaa8dbc0"
DOMAIN="ruanb"

echo "Updating DuckDNS for $DOMAIN..."
RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=")

if [ "$RESPONSE" = "OK" ]; then
    echo "DuckDNS updated successfully."
else
    echo "DuckDNS update failed: $RESPONSE"
fi

