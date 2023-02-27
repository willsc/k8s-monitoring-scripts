#!/bin/bash

# Define the SFTP server details
SFTP_HOST="example.com"
SFTP_PORT="22"
SFTP_USER="username"
SFTP_REMOTE_DIR="/path/to/files/on/remote/server"

# Define the local download directory
LOCAL_DOWNLOAD_DIR="/path/to/local/download/directory"

# Define the download patterns file
DOWNLOAD_PATTERNS_FILE="/path/to/download/patterns/file"

# Define the log file path
LOG_FILE="/path/to/download.log"

# Define the HTTP proxy details
HTTP_PROXY_HOST="proxy.example.com"
HTTP_PROXY_PORT="8080"
HTTP_PROXY_USER="proxy_username"
HTTP_PROXY_PASS="proxy_password"

# Define the SFTP command
SFTP_COMMAND="sftp -o ProxyCommand='nc -x $HTTP_PROXY_HOST:$HTTP_PROXY_PORT %h %p' \
            -o User=$SFTP_USER \
            -P $SFTP_PORT \
            $SFTP_HOST"

# Set the environment variables required by the proxy
export http_proxy="http://$HTTP_PROXY_USER:$HTTP_PROXY_PASS@$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"
export https_proxy="http://$HTTP_PROXY_USER:$HTTP_PROXY_PASS@$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

# Loop through each pattern in the download patterns file and download matching files recursively
while read pattern; do
    # Execute the SFTP command in the background and redirect its output to /dev/null
    nohup bash -c "$SFTP_COMMAND << EOF > /dev/null
    lcd $LOCAL_DOWNLOAD_DIR
    cd $SFTP_REMOTE_DIR
    get -r $pattern
    bye
EOF
" &

    # Log the downloaded files to the log file
    echo "$(date) - Downloaded files recursively matching pattern '$pattern'" >> "$LOG_FILE"
done < "$DOWNLOAD_PATTERNS_FILE"

# Unset the proxy environment variables
unset http_proxy
unset https_proxy

#nohup bash /path/to/script.sh > /dev/null 2>&1 &


