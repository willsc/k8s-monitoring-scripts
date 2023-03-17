#!/usr/bin/env python3


import csv
import argparse
import datetime
from datetime import datetime

# Define command line arguments
parser = argparse.ArgumentParser(description='Subtract two nanosecond timestamp columns from two CSV files.')
parser.add_argument('file1', type=str, help='path to first CSV file')
parser.add_argument('file2', type=str, help='path to second CSV file')
parser.add_argument('column1', type=int, help='column index of the first timestamp column to subtract (0-indexed)')
parser.add_argument('column2', type=int, help='column index of the second timestamp column to subtract (0-indexed)')
args = parser.parse_args()

# Open the first file and read in the data
with open(args.file1, 'r') as file1:
    reader1 = csv.reader(file1)
    data1 = list(reader1)

# Open the second file and read in the data
with open(args.file2, 'r') as file2:
    reader2 = csv.reader(file2)
    data2 = list(reader2)

# Check that the two files have the same number of rows
if len(data1) != len(data2):
    raise ValueError('CSV files must have the same number of rows')

# Check that the specified columns exist in both files
if args.column1 >= len(data1[0]) or args.column2 >= len(data2[0]):
    raise ValueError('Invalid column index specified')

# Subtract the specified columns from each row and store the results in a new list
results = []
for i in range(len(data1)):
    row1 = data1[i]
    row2 = data2[i]
    timestamp1 = row1[args.column1]
    timestamp2 = row2[args.column2]
    time1 = int(timestamp1)
    time2 = int(timestamp2)
    # Convert the timestamps to integers
    delta = time2 - time1
    results.append(delta)

# Print out the results
#for result in results:
#    print(result)

# write the results into a new csv file with the columns of the first and second file and the difference between the two columns
with open('results.csv', 'w', newline='') as csvfile:
    fieldnames = ['timestamp1', 'timestamp2', 'difference']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for i in range(len(results)):
        writer.writerow({'timestamp1': data1[i][0], 'timestamp2': data2[i][0], 'difference': results[i]})



# How to run the script:
# python3 csvreader.py test1.csv test2.csv 0 0
















