FROM percona/percona-server:8.0.33-25

USER root

RUN :\
    && mkdir /home/mysql \
    && chown mysql:mysql /home/mysql \
    && yum install -y percona-mysql-shell.x86_64 \
    && :

USER mysql
