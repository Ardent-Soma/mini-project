#!/bin/bash

# Configuration

#directories to back up

SOURCE_DIR=(
    "/var/www/"
    "/home/soma/"
    "/etc/nginx/"
    "/var/log/" 

)

BACKUP_DIR="/path/to/backup/location"      # Directory where backups will be stored
MAX_BACKUPS=3                               # Number of recent backups to keep
LOG_FILE="/var/log/backup_manager.log"      # Log file path

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Create a timestamped backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo "$(date +"%Y-%m-%d %H:%M:%S") - Starting backup of ${SOURCE_DIR} to ${BACKUP_PATH}" | tee -a "$LOG_FILE"

# Create the backup archive
tar -czf "$BACKUP_PATH" -C "$SOURCE_DIR" .

# Verify the integrity of the backup
if tar -tzf "$BACKUP_PATH" &>/dev/null; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Backup created successfully: ${BACKUP_PATH}" | tee -a "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Backup failed: ${BACKUP_PATH}" | tee -a "$LOG_FILE"
    exit 1
fi

# Implement the rotation policy
echo "$(date +"%Y-%m-%d %H:%M:%S") - Checking for old backups to remove..." | tee -a "$LOG_FILE"

# List backups sorted by date (oldest first) and store them in an array
BACKUPS=($(ls -1t "${BACKUP_DIR}"/backup_*.tar.gz))

# Count the number of backups
NUM_BACKUPS=${#BACKUPS[@]}

# Remove older backups if the number exceeds MAX_BACKUPS
if [ "$NUM_BACKUPS" -gt "$MAX_BACKUPS" ]; then
    NUM_TO_DELETE=$((NUM_BACKUPS - MAX_BACKUPS))
    for ((i=0; i<NUM_TO_DELETE; i++)); do
        rm -f "${BACKUPS[$((NUM_BACKUPS - i - 1))]}"
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Removed old backup: ${BACKUPS[$((NUM_BACKUPS - i - 1))]}" | tee -a "$LOG_FILE"
    done
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - No old backups to remove." | tee -a "$LOG_FILE"
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") - Backup process completed." | tee -a "$LOG_FILE"

