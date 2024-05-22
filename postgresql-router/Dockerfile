FROM ubuntu:22.04 as pgbouncer_builder

RUN apt update \
    && apt dist-upgrade -y \
    && apt install -y git autoconf automake pandoc libtool \
       libevent-dev build-essential pkg-config python3 \
    && git clone https://github.com/pgbouncer/pgbouncer.git \
    && cd pgbouncer \
    && git submodule init \
    && git submodule update \
    && ls -lash \
    && ./autogen.sh \
    && dpkg -L openssl \
    && ./configure --without-openssl \
    && make \
    && make install

FROM ubuntu:22.04

ENV TINI_VERSION v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

COPY entrypoint.sh /entrypoint.sh

RUN apt update \
    && apt install -y git vim libevent-2.1-7 lsb-release wget gnupg2 \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt install -y pgpool2 libpgpool2 \
    && chmod +x /entrypoint.sh /tini

COPY --from=pgbouncer_builder /usr/local/bin/pgbouncer /usr/local/bin/pgbouncer

ENTRYPOINT ["/tini", "--", "./entrypoint.sh"]

