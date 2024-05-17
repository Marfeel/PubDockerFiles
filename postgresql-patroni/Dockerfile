FROM postgres:16.3

# Patroni Config: patroni.yml must be mounted in /etc/patroni.yml
# Postgresql data dir must be mounted in /data/patroni directory

RUN apt-get update -y \
    && apt-get install -y python3 python3-pip pipx vim-tiny \
    && mkdir /data/patroni -p \
    && chown postgres:postgres /data/patroni \
    && chmod 700 /data/patroni
COPY entrypoint.sh ./entrypoint.sh
USER postgres
RUN pipx install patroni[psycopg3,zookeeper] \
    && pipx ensurepath

ENTRYPOINT ["bin/sh", "/entrypoint.sh"]
