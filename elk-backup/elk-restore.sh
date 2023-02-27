#!/bin/bash

# Set the Elasticsearch server URL and snapshot repository name
ELASTICSEARCH_URL="http://localhost:9200"
REPO_NAME="my_backup_repo"

# Set the path to the backup file
BACKUP_FILE="/path/to/elasticsearch-backup.tar.gz"

# Stop the Elasticsearch service
sudo systemctl stop elasticsearch

# Extract the backup file to a temporary directory
TMP_DIR=$(mktemp -d)
tar -xzvf "$BACKUP_FILE" -C "$TMP_DIR"

# Use the Elasticsearch snapshot API to restore the indices from the backup
for INDEX_DIR in "$TMP_DIR"/*; do
    INDEX_NAME=$(basename "$INDEX_DIR")
    curl -X POST "$ELASTICSEARCH_URL/_snapshot/$REPO_NAME/$INDEX_NAME/_restore?wait_for_completion=true" -H 'Content-Type: application/json' -d '{"indices": "'"$INDEX_NAME"'"}'
done

# Remove the temporary directory
rm -rf "$TMP_DIR"

# Start the Elasticsearch service
sudo systemctl start elasticsearch

