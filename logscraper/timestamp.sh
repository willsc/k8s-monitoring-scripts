#!/bin/bash

# Enter the path to the log file to search
log_file="/path/to/logfile.log"

# Enter the pattern to search for
pattern="UNAVAILABLE\|AVAILABLE"

# Enter the name of the CSV file to create
csv_file="log-timestamps.csv"

# Enter the SSH username to use
ssh_user="your_username"

# Enter the SSH password to use
ssh_pass="your_password"

# Enter the list of hosts to SSH into
hosts=(
    "host1.example.com"
    "host2.example.com"
    "host3.example.com"
)

# Loop through each host and SSH into it
for host in "${hosts[@]}"
do
    # SSH into the host and extract the matching lines from the log file
    matching_lines=$(sshpass -p "$ssh_pass" ssh "$ssh_user@$host" "grep '$pattern' '$log_file'")
    
    # Initialize variables for storing the latest timestamp and matching line
    latest_timestamp=0
    latest_line=""

    # Loop through each matching line and extract the timestamp
    while read -r line
    do
        # Extract the timestamp from the line's first and second fields
        timestamp1=$(echo "$line" | awk '{print $1" "$2}')
        timestamp2=$(echo "$line" | awk '{print $4" "$5}')

        # Convert the timestamps to seconds since January 1, 1970
        timestamp1=$(date -d "$timestamp1" +%s)
        timestamp2=$(date -d "$timestamp2" +%s)

        # Check if the line contains "AVAILABLE"
        if echo "$line" | grep -q "AVAILABLE"
        then
            # Check if the second timestamp is later than the latest timestamp
            if [ $timestamp2 -gt $latest_timestamp ]
            then
                # If so, update the latest timestamp and matching line
                latest_timestamp=$timestamp2
                latest_line=$line
            fi
        else
            # Check if the first timestamp is later than the latest timestamp
            if [ $timestamp1 -gt $latest_timestamp ]
            then
                # If so, update the latest timestamp and matching line
                latest_timestamp=$timestamp1
                latest_line=$line
            fi
        fi
    done <<< "$matching_lines"

    # Output the latest matching line to the CSV file
    echo "$host,$latest_line" >> "$csv_file"
done

