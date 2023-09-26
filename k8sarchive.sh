#!/bin/bash

# Check if the required arguments are provided
if [ $# -lt 4 ]; then
    echo "Usage: $0 <kubeconfig> <namespace> <label_selector> <archive_directory>"
    exit 1
fi

KUBECONFIG_FILE="$1"
NAMESPACE="$2"
LABEL_SELECTOR="$3"
ARCHIVE_DIR="$4"

# Set the location of kubectl binary
KUBECTL="/usr/local/bin/kubectl"

# Verify that kubectl is installed
if ! command -v "$KUBECTL" &> /dev/null; then
    echo "kubectl not found. Please make sure kubectl is installed and in your PATH."
    exit 1
fi

# Set the date for the previous day in YYYY-MM-DD format
PREVIOUS_DAY=$(date -d "yesterday" "+%Y-%m-%d")

# Construct the expected archive file name for the previous day
EXPECTED_ARCHIVE="$PREVIOUS_DAY.gz"

# Initialize an array to store pod names matching the label selector
declare -a PODS

# Get the list of pod names that match the label selector in the specified namespace
POD_LIST=$("$KUBECTL" --kubeconfig="$KUBECONFIG_FILE" -n "$NAMESPACE" get pods -l "$LABEL_SELECTOR" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through the pod names and check for the archive file in each pod
for POD_NAME in $POD_LIST; do
    # Command to run inside the pod to check for the archive file
    CHECK_COMMAND="[ -e $ARCHIVE_DIR/$EXPECTED_ARCHIVE ] && echo 'Archive exists' || echo 'Archive does not exist'"
    
    # Use kubectl exec to run the command inside the pod and store the result in a variable
    ARCHIVE_CHECK_RESULT=$("$KUBECTL" --kubeconfig="$KUBECONFIG_FILE" -n "$NAMESPACE" exec -it "$POD_NAME" -- /bin/sh -c "$CHECK_COMMAND")

    # Define a timestamp for the CSV file name
    TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")

    # Create a CSV file with the timestamp as its name
    CSV_FILE="${TIMESTAMP}.csv"
    
    # Determine the status of the archive and write it to the CSV file
    if [ "$ARCHIVE_CHECK_RESULT" == "Archive exists" ]; then
        echo "$TIMESTAMP,$POD_NAME,Archive exists" >> "$CSV_FILE"
    else
        echo "$TIMESTAMP,$POD_NAME,Archive does not exist" >> "$CSV_FILE"
    fi

    # Add the pod name to the array of pods
    PODS+=("$POD_NAME")
done

# Print the result
cat "$CSV_FILE"

# Print the list of pods checked
echo "Pods Checked:"
for POD_NAME in "${PODS[@]}"; do
    echo "$POD_NAME"
done
