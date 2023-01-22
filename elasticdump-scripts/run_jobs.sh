#!/bin/bash

HOST=${ES_HOST:-"localhost"}
PORT=${ES_PORT:-"9200"}
INDEX_PAT="fluentd-"

idx_list=$(curl -sS "${HOST}:${PORT}/_cat/indices?v"  | grep "$INDEX_PAT" | awk -F " " '{ print $3 }')

for idx in $idx_list; do
  echo ";;; Transferring $idx"
  ./estransfer.sh "$idx"
  echo ""
done
