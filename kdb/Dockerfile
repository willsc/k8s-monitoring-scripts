FROM centos:7

ENV QHOME /kdb  
ENV PATH $QHOME/l64:$PATH
ENV QLIC /kdb
RUN mkdir -p $QHOME

RUN yum install -y wget ca-certificates \
        curl \
        rlwrap \
        runit \
        unzip 

COPY q.k /kdb 
COPY l64 /kdb/l64
COPY kc.lic /kdb

RUN alias q='QHOME=~/q rlwrap -r ~/kdb/l64/q'

WORKDIR /kdb
CMD ["q",  "-p", "5000"]

EXPOSE 5000

