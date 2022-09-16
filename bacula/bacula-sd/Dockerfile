FROM marfeel/bacula-base:13.0.0-1

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bacula-cloud-storage

RUN for i in `ls /opt/bacula/bin`; do if test -z /usr/sbin/$i; then ln -s /opt/bacula/bin/$i /usr/sbin/$i; fi; done

ENTRYPOINT ["/opt/bacula/bin/bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
