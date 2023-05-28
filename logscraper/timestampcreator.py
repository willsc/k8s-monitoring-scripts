#!/usr/bin/env python3

#create function that generate  3 columns of different nanoseconds timestamp in a two different  csv files with 1000 rows

import csv
import time
import datetime
import random
import string
import pandas as pd


def randomword(length):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(length))



def generate_timestamps():
    with open('test1.csv', 'w', newline='') as csvfile:
        fieldnames = ['timestamp', 'timestamp2', 'timestamp3']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(1000):
            writer.writerow({'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp2': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp3': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")})

    with open('test2.csv', 'w', newline='') as csvfile:
        fieldnames = ['timestamp', 'timestamp2', 'timestamp3']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(1000):
            writer.writerow({'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp2': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp3': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")})

    with open('test3.csv', 'w', newline='') as csvfile:
        fieldnames = ['timestamp', 'timestamp2', 'timestamp3']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(1000):
            writer.writerow({'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp2': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp3': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")})

    with open('test4.csv', 'w', newline='') as csvfile:
        fieldnames = ['timestamp', 'timestamp2', 'timestamp3']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(1000):
            writer.writerow({'timestamp': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"), 'timestamp2': datetime

# call the function
generate_timestamps()

