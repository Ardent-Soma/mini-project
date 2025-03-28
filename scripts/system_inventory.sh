#!/bin/bash

# -----------------------------
# Simple System Inventory Script
# -----------------------------
# This script will:
# 1. Collect CPU, Memory, and Disk Information
# 2. List Installed Packages
# 3. List Running Services
# 4. Save everything to a report file
# -----------------------------

# Output file name
OUTPUT="system_inventory_report.txt"

# Clear old report (if any)
> $OUTPUT

# Report Header
echo "===== Simple System Inventory Report =====" | tee -a $OUTPUT
echo "Date and Time: $(date)" | tee -a $OUTPUT
echo "==========================================" | tee -a $OUTPUT

# --------------------------------------
# Collect CPU Information
# --------------------------------------
echo -e "\n[CPU Information]" | tee -a $OUTPUT
lscpu | tee -a $OUTPUT

# --------------------------------------
# Collect Memory Information
# --------------------------------------
echo -e "\n[Memory Information]" | tee -a $OUTPUT
free -h | tee -a $OUTPUT

# --------------------------------------
# Collect Disk Information
# --------------------------------------
echo -e "\n[Disk Information]" | tee -a $OUTPUT
lsblk | tee -a $OUTPUT

# --------------------------------------
# List Installed Packages
# --------------------------------------
echo -e "\n[Installed Packages]" | tee -a $OUTPUT

# Check if dpkg (Debian/Ubuntu) exists
if command -v dpkg > /dev/null; then
    dpkg -l | tee -a $OUTPUT
# Check if rpm (RedHat/Fedora) exists
elif command -v rpm > /dev/null; then
    rpm -qa | tee -a $OUTPUT
else
    echo "No supported package manager found." | tee -a $OUTPUT
fi

# --------------------------------------
# List Running Services
# --------------------------------------
echo -e "\n[Running Services]" | tee -a $OUTPUT

# Check if systemctl exists
if command -v systemctl > /dev/null; then
    systemctl list-units --type=service --state=running | tee -a $OUTPUT
else
    # For older systems
    service --status-all 2>/dev/null | grep '+' | tee -a $OUTPUT
fi

# --------------------------------------
# End of Report
# --------------------------------------
echo -e "\nReport saved as: $OUTPUT"

