# This Dockerfile was generated from templates/Dockerfile.j2
FROM centos:7

RUN yum update -y && \
yum install -y procps findutils tar gzip curl 

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 logstash && \
    useradd --uid 1000 --gid 1000 --home /usr/share/logstash logstash
COPY logstash-8.6.0-linux-x86_64.tar.gz /tmp 
RUN cd /tmp && \
    tar -xzf logstash-8.6.0-linux-x86_64.tar.gz && \
    rm logstash-8.6.0-linux-x86_64.tar.gz
   
RUN cp -rp /tmp/logstash-8.6.0/* /usr/share/logstash && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash && \
    mkdir /licenses/ && \
    mv /usr/share/logstash/NOTICE.TXT /licenses/NOTICE.TXT && \
    mv /usr/share/logstash/LICENSE.txt /licenses/LICENSE.txt && \
find /usr/share/logstash -type d -exec chmod g+s {} \; && \
ln -s /usr/share/logstash /opt/logstash

WORKDIR /usr/share/logstash
ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH

# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
COPY config/pipelines.yml config/pipelines.yml
COPY config/logstash-full.yml config/logstash.yml
COPY config/log4j2.properties config/
COPY pipeline/default.conf pipeline/logstash.conf
RUN chown --recursive logstash:root config/ pipeline/
# Ensure Logstash gets the correct locale by default.
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
COPY env2yaml/env2yaml /usr/local/bin/
# Place the startup wrapper script.
COPY bin/docker-entrypoint /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint

USER 1000

EXPOSE 9600 5044

LABEL  org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.opencontainers.image.vendor="Elastic" \
  org.label-schema.name="logstash" \
  org.opencontainers.image.title="logstash" \
  org.label-schema.version="8.6.0" \
  org.opencontainers.image.version="8.6.0" \
  org.label-schema.url="https://www.elastic.co/products/logstash" \
  org.label-schema.vcs-url="https://github.com/elastic/logstash" \
  org.label-schema.license="Elastic License" \
  org.opencontainers.image.licenses="Elastic License" \
  org.opencontainers.image.description="Logstash is a free and open server-side data processing pipeline that ingests data from a multitude of sources, transforms it, and then sends it to your favorite 'stash.'" \
  org.label-schema.build-date=2023-01-04T19:40:57+00:00 \
org.opencontainers.image.created=2023-01-04T19:40:57+00:00
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]


