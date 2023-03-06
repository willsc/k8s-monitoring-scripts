#!/bin/bash

# Enter the path to the file to search
file_path="logfile"

# Search for lines containing "UNAVAILABLE" and "AVAILABLE"
unavailable_lines=$(grep "UNAVAILABLE" "$file_path")
available_lines=$(grep "AVAILABLE" "$file_path")

# Initialize variables for storing the latest timestamp and matching line
latest_timestamp=0
latest_line=""

# Loop through each "AVAILABLE" line and extract the timestamp
while read -r line
do
    # Extract the timestamp from the line
    timestamp=$(echo "$line" | awk '{print $1" "$2}')
    timestamp=$(date -jf "%Y-%m-%d %H:%M:%S" "$timestamp" +%s) 
    # Check if the current timestamp is later than the latest timestamp
    if [ $timestamp  > $latest_timestamp ]
    then
        # If so, update the latest timestamp and matching line
        latest_timestamp=$timestamp
        latest_line=$line
    fi
done <<< "$available_lines"

# Check if the latest "AVAILABLE" line is after the latest "UNAVAILABLE" line
if [ $(echo "$latest_line" | awk '{print $1" "$2}') -gt $(echo "$unavailable_lines" | tail -n 1 | awk '{print $1" "$2}') ]
then
    echo "$latest_line"
else
    echo "No 'AVAILABLE' lines found after the latest 'UNAVAILABLE' line."
fi

