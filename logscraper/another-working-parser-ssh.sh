#!/bin/bash

# Log file path to extract data from
LOG_FILE="/path/to/log/file.log"

# CSV file path to write results to
CSV_FILE="/path/to/output/file.csv"

# List of hosts to SSH into
HOSTS=(
    "host1.example.com"
    "host2.example.com"
    "host3.example.com"
)

# Loop over hosts and extract latest occurrence of patterns
for host in "${HOSTS[@]}"
do
    echo "Processing host: $host"

    # SSH into host and extract latest occurrence of patterns
    latest_available=$(ssh "$host" "awk '/\[PROD-FLOWVOL-SERVER1\[AVAILABLE\]]/ || /\[FEP-CLIENT\[AVAILABLE\]]/ {last=\$0} END {print last}' $LOG_FILE")

    # Check if there is a latest occurrence of patterns
    if [ -n "$latest_available" ]
    then
        # Write result to CSV file
        echo "$host,$latest_available" >> "$CSV_FILE"
    else
        # Write UNAVAILABLE status to CSV file
        echo "$host,UNAVAILABLE" >> "$CSV_FILE"
    fi
done

echo "Done!"

