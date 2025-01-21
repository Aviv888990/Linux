#!/usr/bin/env bash

target_dir="/usr/local/bin"

scripts=("monitor.sh" "backup.sh" "cleanup.sh" "menu.sh")

# Function to copy scripts and set permissions
install_scripts() {
    echo "Installing scripts to $target_dir..."
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            sudo cp "$script" "$target_dir"
            sudo chmod +x "$target_dir/$script"
            echo "Installed $script to $target_dir."
        else
            echo "Error: $script not found in the current directory."
            exit 1
        fi
    done
}

# Function to set up cron jobs
setup_cron_jobs() {
    echo "Setting up cron jobs..."

    # Add a cron job for system monitoring every hour
    (crontab -l 2>/dev/null; echo "0 * * * * $target_dir/monitor.sh") | crontab -

    # Add a cron job for backups twice a month (on the 4th and 20th day of the month)
    (crontab -l 2>/dev/null; echo "0 0 4,20 * * $target_dir/backup.sh") | crontab -

    # Add a cron job for cleanup once a month (1st day at midnight)
    (crontab -l 2>/dev/null; echo "0 0 1 * * $target_dir/cleanup.sh") | crontab -

    echo "Cron jobs successfully set up."
}

# Main installation process
install_scripts
setup_cron_jobs

echo "Bootstrap process complete."
