# k8s-monitoring-scripts
```
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
```

```
import subprocess
import csv


class DiskUsage:
    """A class to get the disk usage of pods in a namespace."""

    def __init__(self, namespace):
        """Initializes the class.

        Args:
            namespace (str): The namespace to get the disk usage for.
        """

        self.namespace = namespace

    def get_disk_usage(self):
        """Gets the disk usage of all pods in the namespace.

        Returns:
            dict: A dictionary of pod names to disk usage.
        """

        pods = subprocess.check_output([
            "kubectl", "get", "pods", "-n", self.namespace, "-o", "name"
        ]).decode("utf-8").strip()

        disk_usage = {}
        for pod in pods.splitlines():
            output = subprocess.check_output([
                "kubectl", "exec", "-it", pod, "--namespace", self.namespace, "--", "df", "-h"
            ]).decode("utf-8").strip()

            for line in output.splitlines():
                if line.startswith("Filesystem"):
                    continue

                fields = line.split()
                disk_usage[pod] = fields[3]

        return disk_usage

    def write_to_csv(self, filename):
        """Writes the disk usage to a CSV file.

        Args:
            filename (str): The name of the CSV file to write to.
        """

        with open(filename, "w") as f:
            writer = csv.writer(f)
            writer.writerow(["pod", "used_space"])
            for pod, used_space in self.get_disk_usage().items():
                writer.writerow([pod, used_space])


def main():
    """The main function."""

    namespace = input("Enter the namespace: ")

    disk_usage = DiskUsage(namespace)
    disk_usage.write_to_csv("disk-usage.csv")


if __name__ == "__main__":
    main()
    ```
    
