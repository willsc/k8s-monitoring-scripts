#!/usr/bin/env python3

import subprocess
import argparse
import os



def list_running_pods():
    command = 'kubectl get pods --field-selector=status.phase=Running --all-namespaces'
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    print(result.stdout)

def list_pods_and_directory(namespace, directory_path):
    command_pods = f'kubectl get pods -n {namespace} '
    result_pods = subprocess.run(command_pods, shell=True, text=True, capture_output=True)
    print(result_pods.stdout)

    print(f"\nContent of the directory '{directory_path}' in each pod:\n")
    for line in result_pods.stdout.split('\n')[1:]:
        if line:
            pod_name = line.split()[0]
            command_ls = f'kubectl exec -n {namespace} {pod_name} --  find {directory_path} -type f -exec stat --printf="%y %n\\n" {{}} \;'
            result_ls = subprocess.run(command_ls, shell=True, text=True, capture_output=True)

            # Combine pod information and directory content side by side
            combined_info = f"Pod: {pod_name}\n{result_ls.stdout}"
            print(combined_info)
            #print('-' * 40)

def copy_file(namespace, pod_name, source_path, destination_path):
    command = f'kubectl cp -n {namespace} {pod_name}:{source_path} {destination_path}'
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    print(result.stdout)

def main():
    parser = argparse.ArgumentParser(description='Kubernetes Utility Script')
    parser.add_argument('-l', '--list-running-pods', action='store_true',
                        help='List running pods and their states')
    parser.add_argument('-V', '--list-pods-and-directory', nargs=2, metavar=('NAMESPACE', 'DIRECTORY_PATH'),
                        help='List pods and the content of a directory side by side in tabular form')
    parser.add_argument('-c', '--copy-file', nargs=4, metavar=('NAMESPACE', 'POD_NAME', 'SOURCE_PATH', 'DESTINATION_PATH'),
                        help='Copy a file from a pod to the local filesystem')

    args = parser.parse_args()

    if args.list_running_pods:
        list_running_pods()

    elif args.list_pods_and_directory:
        namespace, directory_path = args.list_pods_and_directory
        list_pods_and_directory(namespace, directory_path)

    elif args.copy_file:
        namespace, pod_name, source_path, destination_path = args.copy_file
        copy_file(namespace, pod_name, source_path, destination_path)

    else:
        print("Please provide a valid command.")

if __name__ == "__main__":
    main()

