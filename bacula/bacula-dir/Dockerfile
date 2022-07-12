FROM bacula-base:latest

MAINTAINER francesc.sanjuan@marfeel.com

RUN apt-get update && apt-get install -y \
    ssmtp \
    bsd-mailx

COPY ./ssmtp.conf /etc/ssmtp/ssmtp.conf

EXPOSE 9101/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
