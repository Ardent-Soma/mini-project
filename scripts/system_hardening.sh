#!/bin/bash

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root. Use sudo or log in as root."
    exit 1
fi

echo "Starting system hardening process..."

# 1. Update System Packages
echo "Updating system packages..."
#apt-get update && apt-get upgrade -y

# 2. Configure SSH Securely
echo "Configuring SSH for enhanced security..."

# Disable root login via SSH
echo "Disabling root login over SSH..."
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password authentication (use key-based authentication)
echo "Disabling password authentication for SSH..."
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Change default SSH port from 22 to a custom port (e.g., 2222)
CUSTOM_SSH_PORT=2222
echo "Changing SSH port to $CUSTOM_SSH_PORT..."
sed -i "s/^#Port 22/Port $CUSTOM_SSH_PORT/" /etc/ssh/sshd_config

# Restart SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart sshd

# 3. Disable Unnecessary Services
echo "Disabling unnecessary services..."

# List of services to disable
SERVICES_TO_DISABLE=(
    "avahi-daemon"   # Zeroconf service discovery
    "cups"           # Printing service
    "bluetooth"      # Bluetooth service
    "nfs-server"     # Network File System server
    "rpcbind"        # RPC service
)

for SERVICE in "${SERVICES_TO_DISABLE[@]}"; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "Disabling and stopping $SERVICE..."
        systemctl disable "$SERVICE"
        systemctl stop "$SERVICE"
    else
        echo "$SERVICE is not active, skipping..."
    fi
done

# 4. Implement Basic Security Policies
echo "Implementing basic security policies..."

# Install and configure UFW (Uncomplicated Firewall)
echo "Installing UFW..."
apt-get install ufw -y

echo "Setting up default UFW policies..."
ufw default deny incoming
ufw default allow outgoing

echo "Allowing SSH on port $CUSTOM_SSH_PORT..."
ufw allow "$CUSTOM_SSH_PORT"/tcp

echo "Enabling UFW..."
ufw --force enable

# Install and configure Fail2Ban
echo "Installing Fail2Ban..."
apt-get install fail2ban -y

echo "Creating Fail2Ban configuration for SSH..."
cat <<EOL >/etc/fail2ban/jail.local
[sshd]
enabled = true
port = $CUSTOM_SSH_PORT
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 600
EOL

echo "Restarting Fail2Ban service..."
systemctl restart fail2ban

echo "System hardening process completed successfully."

