#!/bin/bash

SCRIPT_DIR="$HOME/Dev/github/ruanb/.dotfiles/scripts"
DUCKDNS_SCRIPT="$SCRIPT_DIR/ssh-server/update-duckdns.sh"

echo "Removing DuckDNS cron job..."
(crontab -l 2>/dev/null | grep -v "$DUCKDNS_SCRIPT") | crontab -
echo "Cron job removed successfully."

