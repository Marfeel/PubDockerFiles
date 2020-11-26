FROM percona/percona-xtrabackup:8.0.13

ADD https://github.com/rlmcpherson/s3gof3r/releases/download/v0.5.0/gof3r_0.5.0_linux_amd64.tar.gz /tmp/gof3r_0.5.0_linux_amd64.tar.gz

RUN tar zxvf /tmp/gof3r_0.5.0_linux_amd64.tar.gz -C /tmp && \
    mv /tmp/gof3r_0.5.0_linux_amd64/gof3r /usr/local/bin/gof3r && \
    rm -rf /tmp/gof3r_0.5.0_linux_amd64* && \
    chmod 0755 /usr/local/bin/gof3r
