#!/usr/bin/env bash

# Define directories to clean
directories=("/var/tmp" "/var/log" "/tmp")
log_file="/var/log/syscleanup.log"
retention_days=17

# Ensure the log file exists
if [ ! -f "$log_file" ]; then
    sudo touch "$log_file"
    sudo chmod 644 "$log_file"
fi

# Function to clean up files and directories older than retention_days
cleanup() {
    echo "Starting cleanup at $(date)" >> "$log_file"

    for dir in "${directories[@]}"; do
        if [ -d "$dir" ]; then
            echo "Cleaning directory: $dir" >> "$log_file"

            # Find and delete files older than retention_days
            find "$dir" -mindepth 1 -type f -mtime +$retention_days -exec rm -f {} \; -exec echo "Deleted file: {}" >> "$log_file" \;

            # Find and delete directories older than retention_days
            find "$dir" -mindepth 1 -type d -mtime +$retention_days -exec rm -rf {} \; -exec echo "Deleted directory: {}" >> "$log_file" \;

        else
            echo "Directory not found: $dir" >> "$log_file"
        fi
    done

    echo "Cleanup completed at $(date)" >> "$log_file"
}

# Run cleanup
cleanup

