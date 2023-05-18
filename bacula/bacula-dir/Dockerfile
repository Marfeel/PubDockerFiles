FROM marfeel/bacula-base:13.0.1-1

LABEL maintainer="Marfeel Ops <ops@marfeel.com>"

RUN apt-get update && apt-get install -y \
    ssmtp \
    openssh-client \
    bsd-mailx \
    unzip

RUN curl -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -fr /tmp/aw*

EXPOSE 9101/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
