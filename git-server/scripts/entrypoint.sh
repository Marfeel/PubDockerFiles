#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash
set -e

create_data_dirs()
{
    mkdir -p \
        "${GIT_SERVER_PATH}/data/keys" \
        "${GIT_SERVER_PATH}/data/users"
}

# The key and symlink functions were adapted from 
# https://github.com/ingwinlu/docker-git-server/blob/master/bootstrap.sh 
maybe_gen_key()
{
    for t in rsa dsa ecdsa ed25519; do
        if [ ! -f "${GIT_SERVER_PATH}/data/keys/ssh_host_${t}_key" ]; then
            echo "Generating ${t} Key..."
            ssh-keygen -q -N '' -t "${t}" -f "${GIT_SERVER_PATH}/data/keys/ssh_host_${t}_key"
            cat "${GIT_SERVER_PATH}/data/keys/ssh_host_${t}_key.pub"
            echo "Generating ${t} Key...Done"
        fi
    done
}

sys_user_files()
{
    for f in passwd group shadow; do
        echo "Linking ${GIT_SERVER_PATH}/data/users/${f}..."
        if [ ! -f "${GIT_SERVER_PATH}/data/users/${f}" ]; then
            cp "/etc/${f}" "${GIT_SERVER_PATH}/data/users/${f}"
        fi
        ln -sf "${GIT_SERVER_PATH}/data/users/${f}" "/etc/${f}"
        echo "Linking ${GIT_SERVER_PATH}/data/users/${f}...Complete"
    done
}

start_sshd()
{
    echo "Starting sshd..."
    /usr/sbin/sshd -E /var/log/sshd.log
}

full_server_start()
{
    create_data_dirs

    maybe_gen_key

    sys_user_files

    manage-git adduser -u "${GIT_USER}" -k "${GIT_USER_PUB_KEY}"
    manage-git create -u "${GIT_USER}" -r test.git

    # start sshd in the bg
    start_sshd &

    tail -F /var/log/*
}

# check for the start command to start sshd and send logs to stdout
if [ "$1" = 'start' ]; then
    full_server_start
fi
# Execute any other command
exec "$@"
