FROM centos:7

RUN yum install -y jdk*  jre* wget && \
    yum clean all && \
    path=$PATH:/opt/jdk/jdk-11.0.2/bin && \
    export PATH 


COPY cerebro-0.9.4.tgz /opt
RUN cd /opt && tar -xvf cerebro-0.9.4.tgz && \
    rm -rf cerebro-0.9.4.tgz && \
    mkdir -p /opt/cerebro-0.9.4/logs && \
    sed -i '/<appender-ref ref="FILE"\/>/d' /opt/cerebro-0.9.4/conf/logback.xml

RUN groupadd -g 1000 cerebro \
 && useradd -r --system  -g 1000 -u 1000 cerebro \
 && chown -R root:root /opt/cerebro-0.9.4 \
 
 && chown -R cerebro:cerebro /opt/cerebro-0.9.4/logs \
 && chown cerebro:cerebro /opt/cerebro-0.9.4

WORKDIR /opt/cerebro-0.9.4
USER cerebro

ENTRYPOINT [ "/opt/cerebro-0.9.4/bin/cerebro" ]

