FROM centos:7
RUN yum -y update && yum -y install libgcc* libstdc++*  git && yum clean all

COPY node-v16.17.0-linux-x64.tar.xz /tmp/node-v16.17.0-linux-x64.tar.xz
RUN mkdir -p /usr/local/lib/nodejs
RUN cd /tmp && tar -xvf node-v16.17.0-linux-x64.tar.xz -C /usr/local/lib/nodejs 
RUN ln -s /usr/local/lib/nodejs/node-v16.17.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /usr/local/lib/nodejs/node-v16.17.0-linux-x64/bin/npx /usr/local/bin/npx && \
    ln -s /usr/local/lib/nodejs/node-v16.17.0-linux-x64/bin/npm /usr/local/bin/npm

COPY elasticsearch-dump /elasticsearch-dump
RUN node -v && npm -v
RUN cd /elasticsearch-dump && \
     npm install  && \
     npm install elasticdump -g 

ENTRYPOINT ["/elasticsearch-dump/bin/elasticdump"]