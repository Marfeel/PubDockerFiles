FROM docker.io/bitnami/postgresql-repmgr:16.2.0-debian-11-r1

USER root

RUN install_packages git build-essential && \
    cd /tmp && \
    git clone --branch v0.4.1 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install

USER 1001
