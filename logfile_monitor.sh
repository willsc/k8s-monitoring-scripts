#!/bin/bash

# Define variables
servers=("server1" "server2" "server3")   # List of servers to SSH into
log_file_path="/path/to/logfile"          # Path to the log file to search
csv_file_path="/path/to/csvfile.csv"      # Path to the CSV file to write results
patterns=("pattern1" "pattern2" "pattern3")  # List of patterns to search for

# Define a function to SSH into a server, search for patterns, and write results to CSV file
search_and_write_to_csv() {
    server=$1
    # SSH into the server and search for each pattern
    for pattern in "${patterns[@]}"; do
        if ssh "$server" grep -q "$pattern" "$log_file_path"; then
            echo "FOUND,$server,$pattern" >> "$csv_file_path"
        else
            echo "OK,$server,$pattern" >> "$csv_file_path"
        fi
    done
}

# Define a function to check for and clean up rogue processes on a server
cleanup_rogue_processes() {
    server=$1
    script_name="script_name.sh"   # Name of the script to check for
    # Search for any running processes of the script and kill them
    ssh "$server" pkill -f "$script_name"
}

# Define a function to check the status of the current script and write it to the CSV file
check_own_status() {
    if pgrep -f "$0" > /dev/null; then
        echo "OK,$(hostname),$(basename "$0")" >> "$csv_file_path"
    else
        echo "ERROR,$(hostname),$(basename "$0")" >> "$csv_file_path"
    fi
}

# Define a function to run the search and cleanup functions for each server
run_for_servers() {
    for server in "${servers[@]}"; do
        search_and_write_to_csv "$server" &
        cleanup_rogue_processes "$server" &
    done
}

# Define a function to run the script process using a scheduler in the background
run_with_scheduler() {
    interval=$1  # Customizable interval in seconds
    while true; do
        # Run the search and cleanup functions for each server
        run_for_servers
        # Check own status and write it to the CSV file
        check_own_status
        sleep "$interval"
    done &
}

# Run the script with a customizable interval of 60 seconds
run_with_scheduler 60





