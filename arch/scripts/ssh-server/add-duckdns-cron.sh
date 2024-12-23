#!/bin/bash

SCRIPT_DIR="$HOME/Dev/github/ruanb/.dotfiles/scripts"
DUCKDNS_SCRIPT="$SCRIPT_DIR/ssh-server/update-duckdns.sh"
CRON_JOB="*/5 * * * * $DUCKDNS_SCRIPT"

echo "Adding DuckDNS cron job..."
(crontab -l 2>/dev/null; echo "$CRON_JOB") | sort -u | crontab -
echo "Cron job added successfully."

