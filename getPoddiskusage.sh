#!/bin/bash

# Define the namespace to monitor
NAMESPACE="mynamespace"

# Define the path to the output CSV file
OUTPUT_FILE="/path/to/output.csv"

# Define the patterns to search for in the pod names (assumes the name format is "<prefix>-<podname>-<suffix>")
PREFIX="myprefix-"
SUFFIX="-mysuffix"

# Define the disk space command to run on each pod
DISK_SPACE_COMMAND="df -h /mnt"

# Define the delay between runs in seconds
DELAY=60

# Function to check if another instance of this script is already running
function check_running() {
  if pidof -o %PPID -x "$0"; then
    echo "Another instance of this script is already running. Exiting."
    exit 1
  fi
}

# Function to run the disk space command on a pod and parse the output
function run_command_on_pod() {
  local pod="$1"
  local command="$2"
  local result=$(kubectl exec "$pod" -n "$NAMESPACE" -- $command | tail -1)
  local usage=$(echo "$result" | awk '{print $5}')
  echo "$pod,$usage"
}

# Function to get the list of pods to monitor
function get_pods() {
  kubectl get pods -n "$NAMESPACE" -o json | jq -r '.items[] | select(.status.phase=="Running") | select(.metadata.name | startswith("'"$PREFIX"'") and endswith("'"$SUFFIX"'")) | .metadata.name' | sort | uniq
}

# Function to aggregate the disk space usage for pods with the same name
function aggregate_usage() {
  local pod="$1"
  local usage="$2"
  local name=$(echo "$pod" | sed "s/^$PREFIX//" | sed "s/$SUFFIX$//")
  local existing=$(grep "^$name," "$OUTPUT_FILE" 2>/dev/null || true)
  if [ -n "$existing" ]; then
    local current=$(echo "$existing" | awk -F, '{print $2}')
    local total=$(echo "$usage $current" | awk '{print $1 + $2}')
    sed -i "s/^$name,.*/$name,$total/" "$OUTPUT_FILE"
  else
    echo "$name,$usage" >> "$OUTPUT_FILE"
  fi
}

# Function to run the monitoring loop
function run_monitor() {
  while true; do
    check_running
    pods=$(get_pods)
    for pod in $pods; do
      usage=$(run_command_on_pod "$pod" "$DISK_SPACE_COMMAND")
      aggregate_usage "$pod" "$usage"
    done
    sleep "$DELAY"
  done
}

# Start the script
check_running
run_monitor &

