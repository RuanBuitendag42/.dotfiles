#!/bin/bash

echo "Enabling Wake-on-LAN..."

# Identify the primary network interface
INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|docker|br|^[^0-9]"{print $2;getline}' | head -n1 | xargs)

if [ -z "$INTERFACE" ]; then
    echo "No suitable network interface found!"
    exit 1
fi

# Enable Wake-on-LAN
sudo ethtool -s "$INTERFACE" wol g

# Make persistent by adding to systemd service
WOL_SERVICE=/etc/systemd/system/wol.service
sudo bash -c "cat > $WOL_SERVICE" <<EOF
[Unit]
Description=Enable Wake-on-LAN
Requires=network.target
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/ethtool -s $INTERFACE wol g

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl enable wol.service

echo "Wake-on-LAN setup complete!"

# b4:2e:99:ee:b0:50
