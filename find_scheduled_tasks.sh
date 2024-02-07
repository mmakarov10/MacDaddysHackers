#!/bin/bash

# Define output file
OUTPUT_FILE="all_scheduled_tasks_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Header
echo "Finding all scheduled tasks..." > "$OUTPUT_FILE"
echo "Generated on $(date)" >> "$OUTPUT_FILE"
echo "-----------------------------------" >> "$OUTPUT_FILE"

# List crontab for all users
echo "Crontab for all users:" >> "$OUTPUT_FILE"
if command_exists crontab; then
    for user in $(cut -f1 -d: /etc/passwd); do
        echo "Crontab for $user:" >> "$OUTPUT_FILE"
        crontab -u "$user" -l 2>> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    done
else
    echo "Crontab command not found, skipping..." >> "$OUTPUT_FILE"
fi

# List system-wide cron directories
CRON_DIRS=("/etc/cron.d" "/etc/cron.daily" "/etc/cron.hourly" "/etc/cron.weekly" "/etc/cron.monthly")
echo "System-wide cron directories:" >> "$OUTPUT_FILE"
for dir in "${CRON_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Contents of $dir:" >> "$OUTPUT_FILE"
        ls -l "$dir" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    else
        echo "$dir does not exist." >> "$OUTPUT_FILE"
    fi
done

# List systemd timers
echo "Systemd timers:" >> "$OUTPUT_FILE"
if command_exists systemctl; then
    systemctl list-timers --all >> "$OUTPUT_FILE"
else
    echo "Systemctl command not found, skipping..." >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Show anacrontab file, if exists
ANACRONTAB_FILE="/etc/anacrontab"
echo "Anacrontab file ($ANACRONTAB_FILE):" >> "$OUTPUT_FILE"
if [ -f "$ANACRONTAB_FILE" ]; then
    cat "$ANACRONTAB_FILE" >> "$OUTPUT_FILE"
else
    echo "Anacrontab file does not exist." >> "$OUTPUT_FILE"
fi

echo "All scheduled tasks have been listed in $OUTPUT_FILE"
