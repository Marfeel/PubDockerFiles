FROM ubuntu:20.04

LABEL maintainer="ops@marfeel.com"

ENV BACULA_VERSION 13.0.0
ENV BACULA_KEY 5cee4d079821e

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata sudo

##### BACULA INSTALL

RUN apt-get update && \
	apt-get install -y wget gnupg restic && \
	wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	apt-key add /tmp/Bacula-4096-Distribution-Verification-key.asc && \
	rm -f /tmp/Bacula-4096-Distribution-Verification-key.asc

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN echo "bacula-mysql	bacula-mysql/dbconfig-install	boolean	false" | debconf-set-selections

RUN apt-get update && apt-get install -y bacula-mysql bacula-console

##### BACULUM INSTALL

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata joe ca-certificates openssl psmisc libffi7 libcurl4

RUN wget -qO - http://bacula.org/downloads/baculum/baculum.pub | apt-key add -

COPY baculum.list /etc/apt/sources.list.d/baculum.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gnupg \
    wget \
    baculum-common \
    baculum-web \
    baculum-web-apache2 \
    baculum-api \
    baculum-api-apache2
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY sudoers-baculum /etc/sudoers.d/sudoers-baculum
COPY messages-web.mo /usr/share/baculum/htdocs/protected/Web/Lang/en/messages.mo
COPY messages-api.mo /usr/share/baculum/htdocs/protected/API/Lang/en/messages.mo

RUN a2ensite baculum-api && \
    a2ensite baculum-web && \
    a2enmod rewrite

EXPOSE 9095/tcp 9096/tcp

CMD ["apache2ctl", "-D", "FOREGROUND"]

