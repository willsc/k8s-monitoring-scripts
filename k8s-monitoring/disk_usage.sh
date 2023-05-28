#!/bin/bash

NAMESPACE="default"
OUTPUT_FILE="disk_usage.csv"

# Get the list of pods in the namespace
PODS=$(kubectl get pods -n $NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Create the CSV file and write the header
echo "Pod Name, Size, Used, Available, Use (%)" > $OUTPUT_FILE

# Iterate over each pod and get the disk usage
for POD in $PODS; do
  # Get the disk usage inside the pod
  DISK_USAGE=$(kubectl exec -n $NAMESPACE $POD -- df -h / | awk 'NR==2{print $2","$3","$4","$5}')

  # Append the pod name and disk usage to the CSV file
  echo "$POD, $DISK_USAGE" >> $OUTPUT_FILE
done

