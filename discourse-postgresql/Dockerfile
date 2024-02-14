FROM docker.io/bitnami/postgresql:16.1.0-debian-11-r18

USER root

RUN install_packages git build-essential && \
    cd /tmp && \
    git clone --branch v0.4.1 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install

USER 1001