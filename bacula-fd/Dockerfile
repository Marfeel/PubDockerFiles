FROM ubuntu:18.04

MAINTAINER Francesc Sanjuán <francesc.sanjuan@fametec.com.br>

ENV BACULA_VERSION 9.4.4

ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && \
	apt-get install -y wget gnupg && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y bacula-mysql --no-install-recommends docker.io && rm -rf /var/lib/apt/lists/*

EXPOSE 9102/tcp

ENTRYPOINT ["opt/bacula/bin/bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
