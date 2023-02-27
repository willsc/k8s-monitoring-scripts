#!/bin/bash

# Set the Elasticsearch server URL and snapshot repository name
ELASTICSEARCH_URL="http://localhost:9200"
REPO_NAME="my_backup_repo"

# Set the backup directory and log file
BACKUP_DIR="/path/to/backup/directory"
LOG_FILE="/path/to/backup/logfile"

# Check if snapshotting is enabled
SNAPSHOT_ENABLED=$(curl -s "$ELASTICSEARCH_URL/_cluster/settings" | jq -r '.persistent.snapshot_enabled')
if [[ $SNAPSHOT_ENABLED == "false" ]]; then
    # Enable snapshotting
    curl -X PUT "$ELASTICSEARCH_URL/_cluster/settings" -H 'Content-Type: application/json' -d '{"persistent": {"snapshot_enabled": true}}'
    echo "Elasticsearch snapshotting is now enabled."
fi

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a timestamp for the backup file name
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Use the Elasticsearch snapshot API to create a snapshot of all indices
curl -X PUT "$ELASTICSEARCH_URL/_snapshot/$REPO_NAME/$TIMESTAMP?wait_for_completion=true" -H 'Content-Type: application/json' -d '{"indices": "_all", "ignore_unavailable": true, "include_global_state": false}'

# Create a tarball of the snapshot data
tar -czvf "$BACKUP_DIR/elasticsearch-$TIMESTAMP.tar.gz" "/var/lib/elasticsearch/nodes/0/indices"

# Delete the snapshot from Elasticsearch
curl -X DELETE "$ELASTICSEARCH_URL/_snapshot/$REPO_NAME/$TIMESTAMP"

# Check if the backup file was created successfully
if [[ $? -eq 0 ]]; then
    # If backup was successful, append a message to the log file
    echo "Backup of all Elasticsearch data completed successfully. Backup file: $BACKUP_DIR/elasticsearch-$TIMESTAMP.tar.gz" >> "$LOG_FILE"
else
    # If backup was not successful, append an error message to the log file
    echo "Error: Backup of all Elasticsearch data failed." >> "$LOG_FILE"
fi

