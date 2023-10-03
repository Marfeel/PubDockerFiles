FROM ubuntu:22.04

LABEL maintainer="Marfeel Ops <ops@marfeel.com>"

ENV BACULA_VERSION 13.0.1
ENV RESTIC_VERSION 0.15.2

ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && \
	apt-get install -y wget bzip2 gnupg openssl curl xmlstarlet jq unzip openssh-client zstd rsync lsb-release libcurl4-openssl-dev libaio1 libev4 && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

RUN wget https://repo.mongodb.org/apt/ubuntu/dists/jammy/mongodb-org/4.4/multiverse/binary-amd64/mongodb-database-tools_100.5.4_amd64.deb && \
    dpkg -i mongodb-database-tools_100.5.4_amd64.deb && \
    rm mongodb-database-tools_100.5.4_amd64.deb

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y bacula-mysql --no-install-recommends docker.io && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/bacula/backup/mongodb

RUN curl https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 -Ls | bunzip2 > /usr/local/bin/restic && \
    chmod a+x /usr/local/bin/restic

RUN wget https://downloads.percona.com/downloads/Percona-XtraBackup-8.0/Percona-XtraBackup-8.0.34-29/binary/debian/jammy/x86_64/percona-xtrabackup-80_8.0.34-29-1.jammy_amd64.deb && \
    dpkg -i percona-xtrabackup-80_8.0.34-29-1.jammy_amd64.deb && \
    rm -f percona-xtrabackup-80_8.0.34-29-1.jammy_amd64.deb

RUN gpg --keyserver  hkp://keyserver.ubuntu.com --recv-keys 1C4CBDCDCD2EFD2A && \
    gpg -a --export CD2EFD2A | apt-key add - && \
    sh -c 'echo "deb http://repo.percona.com/apt jammy main" >> /etc/apt/sources.list.d/percona.list'

RUN wget http://repo.percona.com/apt/pool/main/q/qpress/qpress_11-3.jammy_amd64.deb && \
    dpkg -i qpress_11-3.jammy_amd64.deb

EXPOSE 9102/tcp

ENTRYPOINT ["opt/bacula/bin/bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
