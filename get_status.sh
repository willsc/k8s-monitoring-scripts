#!/bin/bash

# Get the list of remote servers from the command line arguments
REMOTE_SERVERS=("$@")

# Specify the log file path on the remote servers
REMOTE_LOG_FILE="/path/to/remote/logfile.log"

# Specify the statuses to search for
STATUSES=("SUCCESS" "COMPLETE" "OK")

# Specify the output CSV file path
CSV_FILE="/path/to/output.csv"

# Write the CSV header
echo "Server,Status,Result" > "$CSV_FILE"

# Loop through each remote server and each status, and check if the status appears in the remote log file
for remote_server in "${REMOTE_SERVERS[@]}"
do
    for status in "${STATUSES[@]}"
    do
        if ssh "$remote_server" "grep -q '$status' $REMOTE_LOG_FILE"; then
            echo "$remote_server,$status,OK" >> "$CSV_FILE"
        else
            echo "$remote_server,$status,Not Found" >> "$CSV_FILE"
        fi
    done
done

