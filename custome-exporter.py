#!/usr/bin/env python3 

# pip install prometheus_client kubernetes psutil

import time
from prometheus_client import start_http_server, Gauge
import psutil
from kubernetes import client, config

# Load Kubernetes configuration
config.load_kube_config()  # If running outside the cluster
# config.load_incluster_config()  # If running inside the cluster

# Create Prometheus gauges
error_count_gauge = Gauge("k8s_log_error_count", "Count of specific error strings in Kubernetes log files", ["error_type"])
archive_count_gauge = Gauge("gz_archive_count", "Total count of gzipped archives in specified directories")
cpu_usage_gauge = Gauge("cpu_usage_percent", "CPU usage percentage")
memory_usage_gauge = Gauge("memory_usage_percent", "Memory usage percentage")
disk_usage_gauge = Gauge("disk_usage_percent", "Disk usage percentage")

# Configuration
NAMESPACE = "your_namespace"  # Kubernetes namespace
LOG_FILE_PATH = "/path/to/logfile.log"  # Path to log file inside the pods
ARCHIVE_DIR_PATH = "/path/to/gz/archives"  # Path to directory with gz archives
ERROR_STRINGS = ["ERROR", "FAILURE", "CRASH"]  # Specific error strings to count

# Function to exec into a pod and run a command
def exec_command_in_pod(pod_name, namespace, command):
    core_api = client.CoreV1Api()
    resp = core_api.connect_get_namespaced_pod_exec(
        name=pod_name,
        namespace=namespace,
        command=command,
        stderr=True,
        stdin=False,
        stdout=True,
        tty=False,
        _preload_content=True,
    )
    return resp.strip()

# Function to count specific log errors in all pods in the namespace
def count_specific_log_errors():
    core_api = client.CoreV1Api()
    pods = core_api.list_namespaced_pod(namespace=NAMESPACE)
    error_counts = {error: 0 for error in ERROR_STRINGS}

    for pod in pods.items:
        output = exec_command_in_pod(pod.metadata.name, NAMESPACE, ["cat", LOG_FILE_PATH])
        for error_string in ERROR_STRINGS:
            count = sum(1 for line in output.split("\n") if error_string in line)
            error_counts[error_string] += count
    
    return error_counts

# Function to count gzipped archives in all pods in the namespace
def count_total_gz_archives():
    core_api = client.CoreV1Api()
    pods = core_api.list_namespaced_pod(namespace=NAMESPACE)
    total_archive_count = 0

    for pod in pods.items:
        output = exec_command_in_pod(pod.metadata.name, NAMESPACE, ["ls", "-l", ARCHIVE_DIR_PATH])
        gz_files = [line for line in output.split("\n") if ".gz" in line]
        total_archive_count += len(gz_files)
    
    return total_archive_count

# Function to get system metrics for the current environment
def get_system_metrics():
    cpu_usage = psutil.cpu_percent(interval=1)
    memory_usage = psutil.virtual_memory().percent
    disk_usage = psutil.disk_usage("/").percent
    return cpu_usage, memory_usage, disk_usage

# Start the Prometheus server on port 8000
start_http_server(8000)

while True:
    # Get specific error counts
    specific_error_counts = count_specific_log_errors()

    # Set error counts in Prometheus
    for error_string, count in specific_error_counts.items():
        error_count_gauge.labels(error_type=error_string).set(count)

    # Get total gz archive count
    total_archive_count = count_total_gz_archives()
    archive_count_gauge.set(total_archive_count)

    # Set system metrics in Prometheus
    cpu_usage, memory_usage, disk_usage = get_system_metrics()
    cpu_usage_gauge.set(cpu_usage)
    memory_usage_gauge.set(memory_usage)
    disk_usage_gauge.set(disk_usage)

    # Wait for a while before the next update
    time.sleep(10)
