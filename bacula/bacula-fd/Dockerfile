FROM ubuntu:18.04

MAINTAINER Francesc Sanjuán <francesc.sanjuan@fametec.com.br>

ENV BACULA_VERSION 9.4.4
ENV RESTIC_VERSION 0.12.1

ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && \
	apt-get install -y wget gnupg curl && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y mongodb-org-shell mongodb-org-tools bacula-mysql --no-install-recommends docker.io && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/bacula/backup/mongodb

RUN curl https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 -Ls | bunzip2 > /usr/local/bin/restic && \
    chmod a+x /usr/local/bin/restic

EXPOSE 9102/tcp

ENTRYPOINT ["opt/bacula/bin/bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
