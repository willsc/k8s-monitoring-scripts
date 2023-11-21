#!/bin/bash

# Check if the required command 'ktutil' is available
if ! command -v ktutil &> /dev/null; then
    echo "Error: 'ktutil' command not found. Please make sure you have Kerberos utilities installed."
    exit 1
fi

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <principal> <output_keytab_file>"
    exit 1
fi

principal="$1"
output_keytab="$2"

# Generate keytab with AES-128 and AES-256 keys using ktutil
ktutil <<EOF
addent -password -p ${principal}@REALM -k 1 -e aes128-cts-hmac-sha1-96
addent -password -p ${principal}@REALM -k 2 -e aes256-cts-hmac-sha1-96
wkt ${output_keytab}
q
EOF

if [ $? -eq 0 ]; then
    echo "Keytab file '${output_keytab}' generated successfully for principal '${principal}' with AES-128 and AES-256 keys."
else
    echo "Error generating keytab file."
    exit 1
fi
