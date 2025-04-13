#!/bin/bash
# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Log file location
LOG_FILE="/var/log/network_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Check for required tools
check_requirements() {
    TOOLS=("netstat" "iftop" "ping")
    MISSING=0
    
    for TOOL in "${TOOLS[@]}"; do
        if ! command -v "$TOOL" &> /dev/null; then
            echo "Required tool '$TOOL' is not installed."
            MISSING=1
        fi
    done
    
    if [ $MISSING -eq 1 ]; then
        echo "Please install missing tools before running this script."
        exit 1
    fi
}

# Function to log with timestamp
log_entry() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

# Function to monitor active network connections
monitor_connections() {
    echo "Monitoring active network connections..."
    log_entry "--- ACTIVE NETWORK CONNECTIONS ---"
    netstat -tunapl | while read -r line; do
        log_entry "$line"
    done
    echo "Active connections logged to $LOG_FILE"
}

# Function to log unusual network activity
log_unusual_activity() {
    echo "Checking for unusual network activity..."
    log_entry "--- UNUSUAL NETWORK ACTIVITY ---"
    netstat -tunapl | awk '$5 !~ /127.0.0.1/ && $6 == "ESTABLISHED" {print}' | while read -r line; do
        log_entry "$line"
    done
    echo "Unusual network activity logged to $LOG_FILE"
}

# Function to test connectivity between servers
test_connectivity() {
    echo "Testing connectivity to specified servers..."
    log_entry "--- CONNECTIVITY TESTS ---"
    SERVERS=("8.8.8.8" "8.8.4.4")  # Example: Google's public DNS servers
    for SERVER in "${SERVERS[@]}"; do
        if ping -c 4 "$SERVER" &> /dev/null; then
            log_entry "Successfully connected to $SERVER"
        else
            log_entry "Failed to connect to $SERVER"
        fi
    done
    echo "Connectivity tests completed."
}

# Function to report bandwidth usage
report_bandwidth_usage() {
    echo "Reporting bandwidth usage..."
    log_entry "--- BANDWIDTH USAGE REPORT ---"
    iftop -t -s 10 -n -N | while read -r line; do
        log_entry "$line"
    done
    echo "Bandwidth usage reported in $LOG_FILE"
}

# Main function to execute all tasks
main() {
    check_requirements
    monitor_connections
    log_unusual_activity
    test_connectivity
    report_bandwidth_usage
    echo "Network monitoring tasks completed. Results saved to $LOG_FILE"
}

# Execute main function
main
