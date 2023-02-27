#!/bin/bash

# Set the file name for the CSV file
file_name="elasticsearch_stats.csv"

# Write the headers to the CSV file
printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" "timestamp" "cluster_name" "status" "number_of_nodes" "number_of_data_nodes" "active_shards" "unassigned_shards" "delayed_unassigned_shards" "initializing_shards" "relocating_shards" "active_primary_shards" "active_shards_percent_as_number" > $file_name

while true; do
  # Get the current timestamp
  timestamp=$(date +"%Y-%m-%d %T")

  # Get the Elasticsearch stats in JSON format
  stats=$(curl -s -X GET "http://localhost:9200/_cluster/health?pretty" -H "Content-Type: application/json")

  # Extract the values we need from the stats using jq
  cluster_name=$(echo $stats | jq -r .cluster_name)
  status=$(echo $stats | jq -r .status)
  number_of_nodes=$(echo $stats | jq -r .number_of_nodes)
  number_of_data_nodes=$(echo $stats | jq -r .number_of_data_nodes)
  active_shards=$(echo $stats | jq -r .active_shards)
  unassigned_shards=$(echo $stats | jq -r .unassigned_shards)
  delayed_unassigned_shards=$(echo $stats | jq -r .delayed_unassigned_shards)
  initializing_shards=$(echo $stats | jq -r .initializing_shards)
  relocating_shards=$(echo $stats | jq -r .relocating_shards)
  active_primary_shards=$(echo $stats | jq -r .active_primary_shards)
  active_shards_percent_as_number=$(echo $stats | jq -r .active_shards_percent_as_number)

  # Write the values to the CSV file with aligned columns
  printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" "$timestamp" "$cluster_name" "$status" "$number_of_nodes" "$number_of_data_nodes" "$active_shards" "$unassigned_shards" "$delayed_unassigned_shards" "$initializing_shards" "$relocating_shards" "$active_primary_shards" "$active_shards_percent_as_number" >> $file_name

  # Sleep for 60 seconds before checking the stats again
  sleep 60
done

