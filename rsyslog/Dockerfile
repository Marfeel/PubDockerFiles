FROM ubuntu:jammy-20230522

LABEL maintainer="ops@marfeel.com"

ENV RSYSLOG_VERSION=8.2304.0-0adiscon3jammy1

RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        software-properties-common \
        gnupg \
    && add-apt-repository ppa:adiscon/v8-stable \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        rsyslog=${RSYSLOG_VERSION} \
        rsyslog-elasticsearch=${RSYSLOG_VERSION} \
        rsyslog-imptcp=${RSYSLOG_VERSION} \
        rsyslog-mmnormalize=${RSYSLOG_VERSION} \
    && apt-get -y --purge --autoremove remove software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

COPY rsyslog.conf /etc/rsyslog.conf
COPY Dockerfile   /Dockerfile

VOLUME [ "/etc/rsyslog.d" ]

EXPOSE 514/tcp
EXPOSE 517/udp

CMD [ "/usr/sbin/rsyslogd", "-n", "-f", "/etc/rsyslog.conf" ]
