FROM ubuntu:22.04

LABEL maintainer="Marfeel Ops <ops@marfeel.com>"

ENV BACULA_VERSION 13.0.1
ENV RESTIC_VERSION 0.15.1

ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && \
	apt-get install -y wget gnupg bzip2 curl && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

RUN curl https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 -Ls | bunzip2 > /usr/local/bin/restic && \
    chmod a+x /usr/local/bin/restic

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y bacula-mysql --no-install-recommends
