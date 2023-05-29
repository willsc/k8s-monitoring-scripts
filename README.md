# k8s-monitoring-scripts

#!/bin/bash

NAMESPACE="your-namespace"
POD_LABEL_SELECTOR="app=your-app-label"
LOG_KEYWORDS=("error" "failed")
CSV_FILE="error_logs.csv"

# Get a list of pods matching the given label selector
pods=$(kubectl get pods -n $NAMESPACE -l $POD_LABEL_SELECTOR -o jsonpath='{.items[*].metadata.name}')

# Create or truncate the CSV file
echo "Pod Name,Error Message" > $CSV_FILE

# Loop through each pod and fetch its logs
for pod in $pods; do
  echo "=== Logs for Pod: $pod ==="

  # Fetch the logs for the pod
  logs=$(kubectl logs -n $NAMESPACE $pod)

  # Check for error messages or messages containing the keywords
  for keyword in "${LOG_KEYWORDS[@]}"; do
    if grep -q -E "(error|$keyword)" <<< "$logs"; then
      # Extract the matching logs
      matching_logs=$(grep -E "(error|$keyword)" <<< "$logs")

      # Append the matching logs to the CSV file
      while IFS= read -r line; do
        echo "$pod,\"$line\"" >> $CSV_FILE
      done <<< "$matching_logs"

      echo "==> Matching log(s) found and saved to $CSV_FILE"
      echo "=========================="
    fi
  done

  echo ""
done
