#!/usr/bin/env python3

from elasticsearch import Elasticsearch
import json

# Define Elasticsearch parameters
ES_HOST = 'localhost'
ES_PORT = 9200

# Define restore parameters
RESTORE_FILE = '/tmp/dump_20230302_223550.json'

# Connect to Elasticsearch
es = Elasticsearch(['http://localhost:9200'])
# Restore Elasticsearch indices and data from file
# Restore Elasticsearch indices and data from file
with open(RESTORE_FILE, 'r') as f:
    for line in f:
        doc = json.loads(line)
        index = doc['_index']
        del doc['_index']
        if not es.indices.exists(index=index):
            # Create index if it doesn't exist
            es.indices.create(index=index)
        if 'found' in doc and doc['found'] == False:
            # Ignore delete operations
            continue
        es.index(index=index, body=doc['_source'], id=doc['_id'])

# Print success message
print(f'Elasticsearch indices and data restored from {RESTORE_FILE}')
