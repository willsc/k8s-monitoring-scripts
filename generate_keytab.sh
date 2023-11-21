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
ktutil_script=$(cat <<EOF
addent -password -p ${principal}@REALM -k 1 -e aes128-cts-hmac-sha1-96
addent -password -p ${principal}@REALM -k 2 -e aes256-cts-hmac-sha1-96
wkt ${output_keytab}
q
EOF
)

ktutil_output=$(echo "$ktutil_script" | ktutil)

# Check for errors in the ktutil output
if [[ "$ktutil_output" =~ "ktutil:" ]]; then
    echo "Error generating keytab file:"
    echo "$ktutil_output"
    exit 1
fi

echo "Keytab file '${output_keytab}' generated successfully for principal '${principal}' with AES-128 and AES-256 keys."

# Verify that the keys have the correct salts
keytab_info=$(klist -kte "${output_keytab}")
aes128_salt=$(echo "$keytab_info" | awk '/aes128-cts-hmac-sha1-96/{print $3}')
aes256_salt=$(echo "$keytab_info" | awk '/aes256-cts-hmac-sha1-96/{print $3}')

if [ "$aes128_salt" != "0" ] && [ "$aes256_salt" != "0" ]; then
    echo "Keys have the correct salts."
else
    echo "Error: Keys do not have the correct salts."
    exit 1
fi
