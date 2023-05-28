#!/usr/bin/env python3

import os
import glob
import re

def search_directory(directory, pattern1, pattern2):
    files = glob.glob(os.path.join(directory, "*.log"))
    latest_file = None
    latest_file_timestamp = 0

    for file in files:
        if re.search(pattern1, file) and re.search(pattern2, file):
            timestamp = os.path.getmtime(file)
            if timestamp > latest_file_timestamp:
                latest_file = file
                latest_file_timestamp = timestamp

    if latest_file:
        print("Latest file:", latest_file)
    else:
        print("No file matching the patterns found.")

# Example usage
directory_to_search = "/Users/cwills/k8s-monitoring-scripts/k8s-monitoring"
pattern1 = r"failed"
pattern2 = r"/var/log/system.log"
search_directory(directory_to_search, pattern1, pattern2)