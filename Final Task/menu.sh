#!/usr/bin/env bash

# Define paths to scripts and log files
monitor_script="/usr/local/bin/monitor.sh"
backup_log="/opt/sysmonitor/backups/backup.log"
cleanup_log="/var/log/syscleanup.log"
log_file="/var/log/sysmonitor.log"

# Function to display the menu
display_menu() {
    echo "====================="
    echo "   System Menu"
    echo "====================="
    echo "1. Log Current Metrics"
    echo "2. Compare Metrics"
    echo "3. View Last Backup Details"
    echo "4. View Last Cleanup Details"
    echo "5. Run Manual Backup"
    echo "6. Run Manual Cleanup"
    echo "7. Exit"
    echo "====================="
}

# Function to handle menu choices
handle_choice() {
    case $1 in
        1)
            echo "Current Metrics from Log:"
            tail -n 20 "$log_file"
            ;;
        2)
            echo "Comparing Metrics..."
            $monitor_script compare_logs | tail -n +1
            ;;
        3)
            echo "Last Backup Details:"
            tail -n 10 "$backup_log"
            ;;
        4)
            echo "Last Cleanup Details:"
            tail -n 10 "$cleanup_log"
            ;;
        5)
            echo "Running manual backup..."
            /usr/local/bin/backup.sh
            ;;
        6)
            echo "Running manual cleanup..."
            /usr/local/bin/cleanup.sh
            ;;
        7)
            echo "Exiting. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Main menu loop
while true; do
    display_menu
    read -p "Enter your choice: " choice
    handle_choice "$choice"
    echo
    read -p "Press Enter to return to the menu..."
done

