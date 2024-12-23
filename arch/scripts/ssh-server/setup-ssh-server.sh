#!/bin/bash

echo "Setting up SSH server..."

# Enable and start the SSH service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service

# Update sshd_config
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#Port.*/Port 22/' /etc/ssh/sshd_config

echo "SSH server setup complete!"
