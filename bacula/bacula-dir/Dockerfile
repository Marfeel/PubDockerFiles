FROM marfeel/bacula-base:13.0.0-1

MAINTAINER francesc.sanjuan@marfeel.com

RUN apt-get update && apt-get install -y \
    ssmtp \
    bsd-mailx

EXPOSE 9101/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
