#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash
set -e

if [ "$#" -eq 0 ]; then
    # If no args passed, execute yq version and exit
    yq --version
else
    # If we get an arg, exec it
    exec "$@"
fi
