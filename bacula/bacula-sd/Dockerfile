FROM marfeel/bacula-base:13.0.1

ENV BACULA_VERSION 13.0.1

ENV BACULA_KEY 5cee4d079821e

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata curl libc-bin libxml2

COPY bacula-repo.list /etc/apt/sources.list.d/bacula-repo.list

RUN	sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/bacula-repo.list && \
    sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/apt/sources.list.d/bacula-repo.list

RUN apt-get update && \
    apt-get install -y bacula-cloud-storage-common=13.0.1-22081215~jammy bacula-cloud-storage-s3=13.0.1-22081215~jammy

RUN for i in `ls /opt/bacula/bin`; do if test -z /usr/sbin/$i; then ln -s /opt/bacula/bin/$i /usr/sbin/$i; fi; done

ENTRYPOINT ["/opt/bacula/bin/bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
