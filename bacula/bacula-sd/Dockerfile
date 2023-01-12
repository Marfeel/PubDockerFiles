FROM marfeel/bacula-base:13.0.1

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata curl libc-bin libxml2

RUN wget https://launchpad.net/~nrbrtx/+archive/ubuntu/libssl1/+files/libssl1.1_1.1.1l-0~202207051306~ubuntu22.04.1_amd64.deb && \
    dpkg -i libssl1.1_1.1.1l-0~202207051306~ubuntu22.04.1_amd64.deb && \
    rm libssl1.1_1.1.1l-0~202207051306~ubuntu22.04.1_amd64.deb

RUN wget https://www.bacula.org/packages/5cee4d079821e/debs/13.0.0/jammy/amd64/dists/jammy/main/binary-amd64/bacula-cloud-storage_13.0.0-1_amd64.deb && \
    dpkg -i bacula-cloud-storage_13.0.0-1_amd64.deb && \
    rm bacula-cloud-storage_13.0.0-1_amd64.deb

RUN for i in `ls /opt/bacula/bin`; do if test -z /usr/sbin/$i; then ln -s /opt/bacula/bin/$i /usr/sbin/$i; fi; done

ENTRYPOINT ["/opt/bacula/bin/bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
