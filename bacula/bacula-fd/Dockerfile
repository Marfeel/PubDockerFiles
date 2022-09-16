FROM ubuntu:22.04

MAINTAINER Marfeel Ops <ops@marfeel.com>

ENV BACULA_VERSION 13.0.0
ENV RESTIC_VERSION 0.12.1

ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && \
	apt-get install -y wget bzip2 gnupg openssl curl && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb && \
	dpkg -i ./libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb && \
	apt update

RUN wget https://repo.mongodb.org/apt/ubuntu/dists/jammy/mongodb-org/4.4/multiverse/binary-amd64/mongodb-database-tools_100.5.4_amd64.deb && dpkg -i mongodb-database-tools_100.5.4_amd64.deb && rm mongodb-database-tools_100.5.4_amd64.deb


COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y bacula-mysql --no-install-recommends docker.io && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/bacula/backup/mongodb

RUN curl https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 -Ls | bunzip2 > /usr/local/bin/restic && \
    chmod a+x /usr/local/bin/restic

EXPOSE 9102/tcp

ENTRYPOINT ["opt/bacula/bin/bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
