FROM mysql:5.7.30

LABEL maintainer="Marfeel Ops <ops@marfeel.com>"

ENV MYSQL_ROOT_PASSWORD password

ENV MYSQL_DATABASE bacula

ENV MYSQL_USER bacula

ENV MYSQL_PASSWORD password

COPY --chown=mysql make_mysql_tables.sql /docker-entrypoint-initdb.d/make_mysql_tables.sql

EXPOSE 3306/tcp
