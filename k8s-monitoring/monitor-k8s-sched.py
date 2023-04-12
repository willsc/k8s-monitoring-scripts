import os
import csv
import time
import subprocess
import sched
from kubernetes import client, config
from datetime import datetime


# Configuration
namespace = "default"
output_file = "pod_disk_usage.csv"
kubeconfig_path = "path/to/kubeconfig"


# Check if the script is already running
script_name = os.path.basename(__file__)
for pid in subprocess.Popen(["pgrep", "-f", script_name], stdout=subprocess.PIPE).stdout:
    if int(pid) != os.getpid():
        print("The script is already running. Exiting...")
        exit()


# Function to get pod disk usage
def get_pod_disk_usage(pod_name):
    cmd = f"kubectl exec -n {namespace} {pod_name} -- df -h / | awk '{{print $5}}' | tail -n 1"
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    if error:
        print(f"Error getting disk usage for {pod_name}: {error}")
        return None
    else:
        return output.decode("utf-8").strip()


# Function to write data to CSV file
def write_to_csv(pod_name, disk_usage):
    with open(output_file, mode="a") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow([datetime.now(), pod_name, disk_usage])


# Function to clear CSV file
def clear_csv_file():
    with open(output_file, mode="w") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(["Timestamp", "Pod Name", "Disk Usage"])


# Function to run the main loop
def run_loop():
    # Initialize Kubernetes client
    config.load_kube_config(config_file=kubeconfig_path)
    v1 = client.CoreV1Api()

    # Clear CSV file before starting
    clear_csv_file()

    # Get list of pods in namespace
    pods = v1.list_namespaced_pod(namespace=namespace).items

    # Loop through pods and get disk usage
    for pod in pods:
        pod_name = pod.metadata.name
        disk_usage = get_pod_disk_usage(pod_name)
        if disk_usage:
            write_to_csv(pod_name, disk_usage)

    # Clear CSV file before next run
    clear_csv_file()


# Initialize scheduler
scheduler = sched.scheduler(time.time, time.sleep)


# Function to schedule the next run
def schedule_next_run():
    now = time.time()
    next_run = now + interval
    scheduler.enterabs(next_run, 1, run_loop)
    print(f"Next run scheduled for {datetime.fromtimestamp(next_run)}")


# Set interval in seconds
interval = 60

# Schedule the first run
schedule_next_run()

# Main loop for the scheduler
while True:
    scheduler.run()
    # If the scheduler stopped running, schedule the next run
    schedule_next_run()

