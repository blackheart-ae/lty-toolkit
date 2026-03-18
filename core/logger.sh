#!/bin/bash

# Logging module
LOG_FILE="$DATA_DIR/activity.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

view_logs() {
    if [ -f "$LOG_FILE" ]; then
        less "$LOG_FILE"
    else
        echo "No logs found"
    fi
}

clear_logs() {
    > "$LOG_FILE"
    echo "Logs cleared"
}
