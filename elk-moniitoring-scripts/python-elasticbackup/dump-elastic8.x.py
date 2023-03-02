#!/usr/bin/env python3

from elasticsearch import Elasticsearch
import json
import datetime

# Define Elasticsearch parameters
ES_HOST = 'localhost'
ES_PORT = 9200

# Define dump parameters
DUMP_DIR = '/tmp'
DUMP_FILE = f'{DUMP_DIR}/dump_{datetime.datetime.now().strftime("%Y%m%d_%H%M%S")}.json'

# Connect to Elasticsearch
es = Elasticsearch(['http://localhost:9200'])

# Dump Elasticsearch indices and data to file
with open(DUMP_FILE, 'w') as f:
    for index in es.indices.get('*'):
        settings = es.indices.get_settings(index)
        mappings = es.indices.get_mapping(index)
        docs = es.search(index=index, body={'query': {'match_all': {}}}, size=10000)
        for doc in docs['hits']['hits']:
            doc['_index'] = index
            f.write(json.dumps(doc))
            f.write('\n')
        f.write(json.dumps({'index': {'_index': index, '_settings': settings[index]['settings'], '_mappings': mappings[index]['mappings']}}))
        f.write('\n')

# Print success message
print(f'Elasticsearch indices and data dumped to {DUMP_FILE}')










