#!/bin/bash

LOG_FILE="logfile.current"
CSV_FILE="output.csv"

# Extract the latest occurrence of lines containing the specified patterns
latest_lines=$(grep '\[PROD-FLOWVOL-SERVER1\[AVAILABLE\]\]\|\[FEP-CLIENT\[AVAILABLE\]\]' "$LOG_FILE" | awk -F' ' '{print $1,$2,$3,$4,$5,$6,$7,$8" "$9,$10}' | sort -r | awk '!seen[$0]++')

# Write the result to a CSV file
if [[ -n "$latest_lines" ]]; then
  echo "$latest_lines" | sed 's/ /,/g' > "$CSV_FILE"
else
  echo "No matching lines found." >&2
fi

