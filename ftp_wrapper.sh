#!/usr/bin/env bash

# Function to take parameters and pass them to the sftp command using a rsa key and http proxy user and password
# Usage: ftp_wrapper.sh -u user -p pass -h host -d directory -f file -k key -P proxy -Pport port
# Example: ftp_wrapper.sh -u user -p pass -h host -d directory -f file -k key -P proxy -Pport port


# Set variables
while getopts u:p:h:d:f:k:P:Pport: option
do
case "${option}"
in
u) USER=${OPTARG};;
p) PASS=${OPTARG};;
h) HOST=${OPTARG};;
d) DIR=${OPTARG};;
f) FILE=${OPTARG};;
k) KEY=${OPTARG};;
P) PROXY=${OPTARG};;
Pport) PORT=${OPTARG};;
esac
done

# check if all parameters are set
if [ -z "$USER" ] || [ -z "$PASS" ] || [ -z "$HOST" ] || [ -z "$DIR" ] || [ -z "$FILE" ] || [ -z "$KEY" ] || [ -z "$PROXY" ] || [ -z "$PORT" ]
then
echo "Usage: ftp_wrapper.sh -u user -p pass -h host -d directory -f file -k key -P proxy -Pport port"
exit 1
fi

# check if proxy is running using ncat
if ! ncat -X connect -x $PROXY:$PORT $HOST 22
then
  echo "Proxy is not running"
  exit 1
fi


# check if key is readable
if ! [ -r $KEY ]
  then
  echo "Key is not readable"
  exit 1
fi


#check sftp site is up via proxy using ncat
if ! ncat -X connect -x $PROXY:$PORT $HOST 22
then
echo "SFTP site is not up"
exit 1
fi






# check connection with sftp server and reconnect if connection is lost then download directory and subdirectories defined by pattern using proxy and restart download from last file downloaded  if connection is lost

function sftp_download {
sftp -o "ProxyCommand nc -X connect -x $PROXY:$PORT %h %p" -i $KEY $USER@$HOST <<EOF
cd $DIR
lcd $DIR
get -r -c $FILE
bye
EOF
if [ $? -eq 0 ]
then
echo "Download complete"
else
echo "Download failed, trying again"
sftp_download
fi
}




# Call function
sftp_download






























}