import os
import time
import csv
from kubernetes import client, config
from apscheduler.schedulers.blocking import BlockingScheduler

# Load the Kubernetes configuration from kubeconfig file
config.load_kube_config()

# Create a Kubernetes API client
api = client.CoreV1Api()

# Define the namespace to monitor
namespace = 'default'

# Define the output CSV file
output_file = 'pod_disk_usage.csv'

# Define the CSV header row
csv_header = ['Pod Name', 'Namespace', 'Status', 'Creation Time', 'Container Name', 'Disk Usage']

# Define the function to monitor pods and retrieve disk usage information
def monitor_pods():
    try:
        # Get the list of pods in the namespace
        pods = api.list_namespaced_pod(namespace)

        # Iterate through each pod
        for pod in pods.items:
            # Get the list of containers in the pod
            containers = pod.spec.containers

            # Iterate through each container
            for container in containers:
                # Get the container name
                container_name = container.name

                # Get the pod name
                pod_name = pod.metadata.name

                # Get the pod namespace
                pod_namespace = pod.metadata.namespace

                # Get the pod status
                pod_status = pod.status.phase

                # Get the pod creation time
                pod_creation_time = pod.metadata.creation_timestamp.strftime('%Y-%m-%d %H:%M:%S')

                # Get the disk usage information for the container
                container_stats = api.read_namespaced_pod_log(pod_name, pod_namespace, container=container_name, tail_lines=1)

                # Write the pod and container information, along with the disk usage, to the CSV file
                with open(output_file, mode='a', newline='') as csv_file:
                    writer = csv.writer(csv_file)
                    writer.writerow([pod_name, pod_namespace, pod_status, pod_creation_time, container_name, container_stats])

    except Exception as e:
        # Handle any exceptions
        print(f'Error: {e}')

# Define the function to check if the script is running and restart if it's not
def check_running():
    pid = os.getpid()
    if not os.path.exists(f'/proc/{pid}'):
        print('Script is not running. Restarting...')
        os.execv(__file__, sys.argv)

# Create a scheduler that runs the monitor_pods function at the defined interval
scheduler = BlockingScheduler()
scheduler.add_job(monitor_pods, 'interval', seconds=10)

# Create a scheduler that checks if the script is running every minute
monitor_scheduler = BlockingScheduler()
monitor_scheduler.add_job(check_running, 'interval', minutes=1)

# Open the CSV file in write mode and write the header row
with open(output_file, mode='w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(csv_header)

    # Start the schedulers
    scheduler.start()
    monitor_scheduler.start()

