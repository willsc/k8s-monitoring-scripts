```
❯ pip download paramiko
Collecting paramiko
  Downloading paramiko-3.0.0-py3-none-any.whl (210 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 210.8/210.8 kB 3.3 MB/s eta 0:00:00
Collecting bcrypt>=3.2
  Downloading bcrypt-4.0.1-cp36-abi3-macosx_10_10_universal2.whl (473 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 473.4/473.4 kB 10.1 MB/s eta 0:00:00
Collecting pynacl>=1.5
  Downloading PyNaCl-1.5.0-cp36-abi3-macosx_10_10_universal2.whl (349 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 349.9/349.9 kB 8.2 MB/s eta 0:00:00
Collecting cryptography>=3.3
  Downloading cryptography-39.0.0-cp36-abi3-macosx_10_12_x86_64.whl (2.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.9/2.9 MB 27.2 MB/s eta 0:00:00
Collecting cffi>=1.12
  Downloading cffi-1.15.1-cp38-cp38-macosx_10_9_x86_64.whl (178 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 178.9/178.9 kB 6.9 MB/s eta 0:00:00
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 kB 4.6 MB/s eta 0:00:00
Saved ./paramiko-3.0.0-py3-none-any.whl
Saved ./bcrypt-4.0.1-cp36-abi3-macosx_10_10_universal2.whl
Saved ./cryptography-39.0.0-cp36-abi3-macosx_10_12_x86_64.whl
Saved ./PyNaCl-1.5.0-cp36-abi3-macosx_10_10_universal2.whl
Saved ./cffi-1.15.1-cp38-cp38-macosx_10_9_x86_64.whl
Saved ./pycparser-2.21-py2.py3-none-any.whl
Successfully downloaded paramiko bcrypt cryptography pynacl cffi pycparser

[notice] A new release of pip available: 22.3 -> 22.3.1
[notice] To update, run: python3.8 -m pip install --upgrade pip
❯ ls
PyNaCl-1.5.0-cp36-abi3-macosx_10_10_universal2.whl    cryptography-39.0.0-cp36-abi3-macosx_10_12_x86_64.whl
bcrypt-4.0.1-cp36-abi3-macosx_10_10_universal2.whl    paramiko-3.0.0-py3-none-any.whl
cffi-1.15.1-cp38-cp38-macosx_10_9_x86_64.whl          pycparser-2.21-py2.py3-none-any.whl
❯ for i in pycparser-2.21-py2.py3-none-any.whl cffi-1.15.1-cp38-cp38-macosx_10_9_x86_64.whl bcrypt-4.0.1-cp36-abi3-macosx_10_10_universal2.whl cryptography-39.0.0-cp36-abi3-macosx_10_12_x86_64.whl PyNaCl-1.5.0-cp36-abi3-macosx_10_10_universal2.whl paramiko-3.0.0-py3-none-any.whl
for> do
for> pip install $i --no-index --find-links '.'
for> done
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./pycparser-2.21-py2.py3-none-any.whl
Installing collected packages: pycparser
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed pycparser-2.21
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./cffi-1.15.1-cp38-cp38-macosx_10_9_x86_64.whl
Requirement already satisfied: pycparser in /usr/local/lib/python3.8/site-packages (from cffi==1.15.1) (2.21)
Installing collected packages: cffi
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed cffi-1.15.1
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./bcrypt-4.0.1-cp36-abi3-macosx_10_10_universal2.whl
Installing collected packages: bcrypt
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed bcrypt-4.0.1
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./cryptography-39.0.0-cp36-abi3-macosx_10_12_x86_64.whl
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.8/site-packages (from cryptography==39.0.0) (1.15.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.8/site-packages (from cffi>=1.12->cryptography==39.0.0) (2.21)
Installing collected packages: cryptography
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed cryptography-39.0.0
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./PyNaCl-1.5.0-cp36-abi3-macosx_10_10_universal2.whl
Requirement already satisfied: cffi>=1.4.1 in /usr/local/lib/python3.8/site-packages (from PyNaCl==1.5.0) (1.15.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.8/site-packages (from cffi>=1.4.1->PyNaCl==1.5.0) (2.21)
Installing collected packages: PyNaCl
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed PyNaCl-1.5.0
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Looking in links: .
Processing ./paramiko-3.0.0-py3-none-any.whl
Requirement already satisfied: bcrypt>=3.2 in /usr/local/lib/python3.8/site-packages (from paramiko==3.0.0) (4.0.1)
Requirement already satisfied: pynacl>=1.5 in /usr/local/lib/python3.8/site-packages (from paramiko==3.0.0) (1.5.0)
Requirement already satisfied: cryptography>=3.3 in /usr/local/lib/python3.8/site-packages (from paramiko==3.0.0) (39.0.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.8/site-packages (from cryptography>=3.3->paramiko==3.0.0) (1.15.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.8/site-packages (from cffi>=1.12->cryptography>=3.3->paramiko==3.0.0) (2.21)
Installing collected packages: paramiko
  DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
DEPRECATION: Configuring installation scheme with distutils config files is deprecated and will no longer work in the near future. If you are using a Homebrew or Linuxbrew Python, please see discussion at https://github.com/Homebrew/homebrew-core/issues/76621
Successfully installed paramiko-3.0.0
❯ pip list
Package            Version
------------------ ---------
apache-beam        2.27.0
apitools           0.1.4
attrs              21.4.0
avro-python3       1.9.2.1
bcrypt             4.0.1
bleach             4.1.0
boto3              1.23.5
botocore           1.26.5
cachetools         5.2.0
certifi            2022.9.24
cffi               1.15.1
chardet            3.0.4
charset-normalizer 2.1.1
click              8.0.3
colorama           0.4.4
crcmod             1.7
cryptography       39.0.0
dill               0.3.1.1
distlib            0.3.4
distro             1.5.0
dnspython          1.16.0
docopt             0.6.2
docutils           0.18.1
email-validator    1.1.1
fastavro           1.3.0
fasteners          0.16
filelock           3.4.2
Flask              2.0.2
Flask-API          3.0.post1
future             0.18.2
google-apitools    0.5.31
google-auth        2.13.0
grpcio             1.35.0
hdfs               2.5.8
httplib2           0.17.4
idna               3.4
importlib-metadata 4.10.1
iniconfig          1.1.1
itsdangerous       2.0.1
Jinja2             3.0.3
jmespath           0.10.0
jsonify            0.5
keyring            23.5.0
kubernetes         23.6.0
MarkupSafe         2.0.1
mock               2.0.0
numpy              1.20.0
oauth2client       4.1.3
oauthlib           3.2.2
packaging          21.3
paramiko           3.0.0
pbr                5.5.1
pip                22.3
pipenv             2022.1.8
pkginfo            1.8.2
platformdirs       2.4.1
pluggy             1.0.0
process-uptime     2021.1.10
protobuf           3.14.0
psutil             5.9.4
py                 1.11.0
pyarrow            2.0.0
pyasn1             0.4.8
pyasn1-modules     0.2.8
pycparser          2.21
pydot              1.4.1
pyfastogt          1.1.0
Pygments           2.11.2
pymongo            3.11.3
PyNaCl             1.5.0
pyparsing          2.4.7
pytest             6.2.5
python-dateutil    2.8.2
python-gitlab      2.0.0
pytz               2021.1
PyYAML             6.0
readme-renderer    32.0
requests           2.28.1
requests-oauthlib  1.3.1
requests-toolbelt  0.9.1
rfc3986            2.0.0
rsa                4.9
s3transfer         0.5.2
setuptools         65.5.0
six                1.16.0
slog               0.11.0
termcolor          1.1.0
toml               0.10.2
tqdm               4.62.3
twine              3.8.0
typing-extensions  3.7.4.3
uritemplate        3.0.1
urllib3            1.26.12
virtualenv         20.13.1
virtualenv-clone   0.5.7
webencodings       0.5.1
websocket-client   1.4.1
Werkzeug           2.0.2
wheel              0.37.1
zipp               3.7.0

[notice] A new release of pip available: 22.3 -> 22.3.1
[notice] To update, run: python3.8 -m pip install --upgrade pip

```
