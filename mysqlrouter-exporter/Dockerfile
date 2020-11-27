FROM ubuntu:20.04

ADD https://github.com/rluisr/mysqlrouter_exporter/releases/download/v2.2.1/mysqlrouter_exporter_linux_x86_64.tar.gz /tmp/mysqlrouter_exporter_linux_x86_64.tar.gz

RUN tar zxvf /tmp/mysqlrouter_exporter_linux_x86_64.tar.gz -C /tmp && \
    mv /tmp/mysqlrouter_exporter /usr/local/bin/mysqlrouter_exporter && \
    chmod a+x /usr/local/bin/mysqlrouter_exporter

ENTRYPOINT ["mysqlrouter_exporter"]

