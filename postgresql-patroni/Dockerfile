FROM percona/percona-distribution-postgresql:16.2

# Patroni Config: patroni.yml must be mounted in /etc/patroni.yml
# Postgresql data dir must be mounted in /data/patroni directory

USER root

COPY entrypoint.sh ./entrypoint.sh

ENV TINI_VERSION v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN yum install python3 python3-pip vim-minimal percona-pgvector_16

RUN chmod +x /tini \
    && mkdir /home/postgres /data/patroni -p \
    && chown postgres:postgres /home/postgres /data/patroni \
    && chmod 700 /data/patroni \
    && chmod a+rx ./entrypoint.sh

USER postgres

RUN pip install patroni[psycopg2,zookeeper]

ENTRYPOINT ["/tini", "--", "./entrypoint.sh"]
