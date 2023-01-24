#!/usr/bin/env python3

import paramiko

# function to parse command line arguments
def parse_args():

    # create a parser object
    parser = argparse.ArgumentParser(description="Download files from sftp server")
    # add the arguments
    parser.add_argument("-s", "--server", help="sftp server", required=True)
    parser.add_argument("-u", "--user", help="sftp user", required=True)
    parser.add_argument("-p", "--password", help="sftp password", required=True)
    parser.add_argument("-k", "--key", help="sftp key file", required=True)
    parser.add_argument("-r", "--remote_path", help="remote path", required=True)
    parser.add_argument("-l", "--local_path", help="local path", required=True)
    parser.add_argument("-P", "--pattern", help="pattern", required=True)
    # parse the arguments
    args = parser.parse_args()
    # return the arguments
    return args

# function to connect to sftp server with keys via an http proxy authenticated with user name and password
def connect_sftp_proxy(host, port, user, password, proxy_host, proxy_port, proxy_user, proxy_password, key_file):
    # create a transport object
    transport = paramiko.Transport((host, port))
    # create a proxy object
    proxy = paramiko.ProxyCommand("nc -X connect -x %s:%s %s %s" % (proxy_host, proxy_port, host, port))
    # connect to the transport object
    transport.connect(username=user, password=password, sock=proxy)
    # create a sftp object
    sftp = paramiko.SFTPClient.from_transport(transport)
    # return the sftp object
    return sftp


#list directories and on sftp server
def list_dir(sftp, path):
    # get the list of files in the path
    files = sftp.listdir(path)
    #   print the files
    for file in files:
        print(file)




# dowload latest directory from sftp server of any specifiec pattern
def download_dir(sftp, remote_path, local_path, pattern):
   # get list of directries in the remote path
    dirs = sftp.listdir(remote_path)
    # create a list of directories that match the pattern
    dirs = [dir for dir in dirs if re.search(pattern, dir)]
    # sort the directories
    dirs.sort()
    # get the latest directory
    latest_dir = dirs[-1]
    # get the list of files in the latest directory
    files = sftp.listdir(remote_path + latest_dir)
    # download the directories
    for file in files:
        sftp.get(remote_path + latest_dir + "/" + file, local_path + file)










# main function
def main():
    # create a sftp object
    sftp = connect_sftp_proxy("sftp.example.com", 22, "user", "password", "proxy.example.com    ", 8080, "proxy_user", "proxy_password", "key_file")
    # list the directories
    list_dir(sftp, "/")
    # download the latest file
    download_dir(sftp, "/remote_path/", "/local_path/", "pattern")
    # close the sftp connection
    sftp.close()


