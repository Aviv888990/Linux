#!/usr/bin/env bash

# Define log file
log_file="/var/log/sysmonitor.log"

# Ensure the log file exists
if [ ! -f "$log_file" ]; then
    sudo touch "$log_file"
    sudo chmod 644 "$log_file"
fi

# Function to log system metrics
log_metrics() {
    echo "--- System Metrics at $(date) ---" >> "$log_file"

    # Log CPU usage
    echo "CPU Usage:" >> "$log_file"
    top -bn1 | grep "Cpu(s)" | awk '{print "User: "$2"% System: "$4"% Idle: "$8"%"}' >> "$log_file"

    # Log memory usage
    echo "Memory Usage:" >> "$log_file"
    free -h | awk '/Mem:/ {print "Used: "$3" Total: "$2}' >> "$log_file"

    # Log disk usage
    echo "Disk Usage:" >> "$log_file"
    df -h / | awk '/\// {print "Used: "$3" Available: "$4" Total: "$2}' >> "$log_file"

    # Log network statistics
    echo "Network Statistics:" >> "$log_file"
    ip -s link | awk '/RX:/ {getline; print "Received Bytes: "$1}' >> "$log_file"
    ip -s link | awk '/TX:/ {getline; print "Transmitted Bytes: "$1}' >> "$log_file"

    echo "--- End of Metrics ---" >> "$log_file"
    echo >> "$log_file"

    # Print the metrics directly to the console
    tail -n 20 "$log_file"
}

# Function to compare metrics to the last log entry
compare_logs() {
    if [ ! -s "$log_file" ]; then
        echo "Log file is empty. Cannot perform comparison."
        return
    fi

    # Extract the line numbers of the last two metric blocks
    block_lines=($(grep -n "^--- System Metrics at" "$log_file" | awk -F: '{print $1}'))
    total_blocks=${#block_lines[@]}

    if [ "$total_blocks" -lt 2 ]; then
        echo "No previous entry available for comparison."
        return
    fi

    # Get the start and end lines for the latest and previous blocks
    latest_start=${block_lines[$((total_blocks - 1))]}
    previous_start=${block_lines[$((total_blocks - 2))]}
    latest_end=$(awk "NR>$latest_start && /^--- End of Metrics ---/{print NR; exit}" "$log_file")
    previous_end=$(awk "NR>$previous_start && /^--- End of Metrics ---/{print NR; exit}" "$log_file")

    # Extract the blocks
    latest_block=$(sed -n "${latest_start},${latest_end}p" "$log_file")
    previous_block=$(sed -n "${previous_start},${previous_end}p" "$log_file")

    echo "--- Comparing Metrics ---"
    echo "Latest Metrics:"
    echo "$latest_block"
    echo
    echo "Previous Metrics:"
    echo "$previous_block"
    echo "--- Comparison Complete ---"
}

log_metrics

