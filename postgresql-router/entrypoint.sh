#!/bin/bash

# Start pgpool
/etc/init.d/pgpool2 start

# Start pgbouncetr
/usr/local/bin/pgbouncer -d "${CONFIG_FILE:-/etc/pgbouncer.conf}"
