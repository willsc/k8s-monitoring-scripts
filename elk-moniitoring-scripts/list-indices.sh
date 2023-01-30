#!/bin/bash

# set variables for Elasticsearch host and port

host=localhost
port=9200

#function to gather all statistics using the Elasticsearch API

function get_stats() {
  curl -s "http://$host:$port/_stats?pretty=true"
}










