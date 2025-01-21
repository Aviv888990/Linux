#!/usr/bin/env bash

# Define the backup directory and source
backup_dir="/opt/sysmonitor/backups"
source_dir="/root/home"
log_file="/opt/sysmonitor/backups/backup.log"

# Ensure the backup directory exists
if [ ! -d "$backup_dir" ]; then
    sudo mkdir -p "$backup_dir"
    sudo chmod 755 "$backup_dir"
fi

# Ensure the log file exists
if [ ! -f "$log_file" ]; then
    sudo touch "$log_file"
    sudo chmod 644 "$log_file"
fi

# Function to create a backup
create_backup() {
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local backup_file="$backup_dir/backup_$timestamp.tar.gz"

    echo "Starting backup at $(date)" >> "$log_file"

    # Check available disk space
    local available_space=$(df --output=avail "$backup_dir" | tail -1)
    if [ "$available_space" -lt 10485760 ]; then # Less than 10GB in KB
        echo "Error: Not enough disk space for backup." >> "$log_file"

        # Remove the oldest backup if space is insufficient
        oldest_backup=$(ls -t "$backup_dir" | tail -n 1)
        if [ -n "$oldest_backup" ]; then
            echo "Removing oldest backup: $oldest_backup" >> "$log_file"
            rm "$backup_dir/$oldest_backup"
        else
            echo "No backups available to delete. Backup aborted." >> "$log_file"
            exit 1
        fi
    fi

    # Create the backup
    tar -czf "$backup_file" "$source_dir" 2>> "$log_file"

    if [ $? -eq 0 ]; then
        echo "Backup successful: $backup_file" >> "$log_file"
    else
        echo "Backup failed." >> "$log_file"
        exit 1
    fi
}

# Run the backup function
create_backup

echo "Backup process complete."

