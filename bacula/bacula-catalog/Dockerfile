FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD "{{ mysql_root_password }}"

ENV MYSQL_DATABASE bacula

ENV MYSQL_USER bacula

ENV MYSQL_PASSWORD "{{ mysql_password }}"

COPY --chown=mysql make_mysql_tables.sql /docker-entrypoint-initdb.d/make_mysql_tables.sql

EXPOSE 3306/tcp
