#!/bin/bash

logfile=logfile.current
csvfile=./output.csv

# Check if log file exists
if [ ! -f "$logfile" ]; then
  echo "Log file not found!"
  exit 1
fi

# Extract the latest occurrence of the patterns
prod_line=$(grep '\[PROD-FLOWVOL-SERVER1\[AVAILABLE\]\]' "$logfile" | tail -n 1)
fep_line=$(grep '\[FEP-CLIENT\[AVAILABLE\]\]' "$logfile" | tail -n 1)

# Write to CSV file
echo "Timestamp,Status" > "$csvfile"
if [ -n "$prod_line" ]; then
  prod_timestamp=$(echo "$prod_line" | awk '{print $1 " " $2}')
  echo "$prod_timestamp,AVAILABLE" >> "$csvfile"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S'),UNAVAILABLE" >> "$csvfile"
fi

if [ -n "$fep_line" ]; then
  fep_timestamp=$(echo "$fep_line" | awk '{print $1 " " $2}')
  echo "$fep_timestamp,AVAILABLE" >> "$csvfile"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S'),UNAVAILABLE" >> "$csvfile"
fi

