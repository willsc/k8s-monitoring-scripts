#!/bin/bash

# Set the name of the CSV file and create the header row
csv_file="pod_status.csv"
echo "Pod Name,Status,Restarts" > $csv_file

# Set the name of the log file and create it
log_file="pod_logs.log"
touch $log_file

# Set the monitoring interval in seconds (default is 60 seconds)
interval=${1:-60}

# Set the maximum number of script runs before clearing the error log
max_runs=5
run_count=0

# Loop continuously, monitoring the pods at the specified interval
while true; do
  # Reset the CSV file before writing to it
  echo "Pod Name,Status,Restarts" > $csv_file
  
  # Loop through each pod and write its status to the CSV file
  for pod in $(kubectl get pods -o jsonpath='{.items[*].metadata.name}'); do
    # Get the pod's status and number of restarts
    status=$(kubectl get pod $pod -o jsonpath='{.status.phase}')
    restarts=$(kubectl get pod $pod -o jsonpath='{.status.containerStatuses[0].restartCount}')

    # Write the pod's name, status, and restarts to the CSV file
    echo "$pod,$status,$restarts" >> $csv_file
    
    # Get the pod's logs and check for error messages
    log=$(kubectl logs $pod)
    if echo "$log" | grep -q "error"; then
      # If error messages are found, append the pod's logs to the log file
      echo "ERROR FOUND in $pod" >> $log_file
      echo "$log" >> $log_file
    fi
  done

  # Increment the run count
  ((run_count++))

  # If it's the fifth run, clear the error log and reset the run count
  if [ $run_count -eq $max_runs ]; then
    echo "Clearing error log after $max_runs runs"
    echo "" > $log_file
    run_count=0
  fi
  
  # Wait for the specified interval before checking the pods again
  sleep $interval
  
  # Check if the script is still running, and restart it if necessary
  pid=$(pgrep -f "$0")
  if [ $(echo "$pid" | wc -l) -gt 1 ]; then
    echo "Restarting script with PID $pid"
    kill $pid
  fi
done

