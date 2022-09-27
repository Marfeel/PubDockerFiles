FROM ubuntu:20.04

LABEL maintainer="ops@marfeel.com"

RUN apt-get update && apt-get install -y --no-install-recommends gnupg wget joe ca-certificates
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

COPY sudoers-baculum /etc/sudoers.d/sudoers-baculum

RUN a2ensite baculum-api && \
    a2ensite baculum-web && \
    a2enmod rewrite

EXPOSE 9095/tcp 9096/tcp

CMD ["apache2ctl", "-D", "FOREGROUND"]
