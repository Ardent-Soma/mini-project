#!/bin/bash

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Log file location
LOG_FILE="/var/log/network_monitor.log"

# Function to monitor active network connections
monitor_connections() {
    echo "Monitoring active network connections..."
    netstat -tunapl > "$LOG_FILE"
    echo "Active connections logged to $LOG_FILE"
}

# Function to log unusual network activity
log_unusual_activity() {
    echo "Checking for unusual network activity..."
    # Example: List established connections to external addresses
    netstat -tunapl | awk '$5 !~ /127.0.0.1/ && $6 == "ESTABLISHED" {print}' >> "$LOG_FILE"
    echo "Unusual network activity logged to $LOG_FILE"
}

# Function to test connectivity between servers
test_connectivity() {
    echo "Testing connectivity to specified servers..."
    SERVERS=("8.8.8.8" "8.8.4.4")  # Example: Google's public DNS servers
    for SERVER in "${SERVERS[@]}"; do
        if ping -c 4 "$SERVER" &> /dev/null; then
            echo "Successfully connected to $SERVER" >> "$LOG_FILE"
        else
            echo "Failed to connect to $SERVER" >> "$LOG_FILE"
        fi
    done
    echo "Connectivity tests completed."
}

# Function to report bandwidth usage
report_bandwidth_usage() {
    echo "Reporting bandwidth usage..."
    # Example using iftop; ensure iftop is installed
    if command -v iftop &> /dev/null; then
        iftop -t -s 10 -n -N > "$LOG_FILE"
        echo "Bandwidth usage reported in $LOG_FILE"
    else
        echo "iftop is not installed. Please install it using your package manager."
    fi
}

# Main function to execute all tasks
main() {
    monitor_connections
    log_unusual_activity
    test_connectivity
    report_bandwidth_usage
    echo "Network monitoring tasks completed."
}

# Execute main function
main

