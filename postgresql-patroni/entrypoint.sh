#!/bin/sh

readonly CONTAINER_IP=${CONTAINER_IP:-$(hostname --ip-address)}
readonly CONTAINER_API_ADDR="${CONTAINER_IP}:${PATRONI_API_CONNECT_PORT}"
readonly CONTAINER_POSTGRE_ADDR="${CONTAINER_IP}:5432"

export PATRONI_NAME="${PATRONI_NAME:-$(hostname)}"
export PATRONI_RESTAPI_CONNECT_ADDRESS="$CONTAINER_API_ADDR"
export PATRONI_RESTAPI_LISTEN="$CONTAINER_API_ADDR"
export PATRONI_POSTGRESQL_CONNECT_ADDRESS="$CONTAINER_POSTGRE_ADDR"
export PATRONI_POSTGRESQL_LISTEN="$CONTAINER_POSTGRE_ADDR"
export PATRONI_REPLICATION_USERNAME="$REPLICATION_NAME"
export PATRONI_REPLICATION_PASSWORD="$REPLICATION_PASS"
export PATRONI_SUPERUSER_USERNAME="$SU_NAME"
export PATRONI_SUPERUSER_PASSWORD="$SU_PASS"
export PATRONI_appuser_PASSWORD="$POSTGRES_APP_ROLE_PASS"
export PATRONI_appuser_OPTIONS="${PATRONI_admin_OPTIONS:-createdb, createrole}"

exec $HOME/.local/bin/patroni /etc/patroni.yml
