FROM alpine:3.11

ARG DUMB_INIT_VERSION=1.2.2

ENV GIT_SERVER_PATH=/git-server \
  GIT_USER=git \
  GIT_USER_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRav5cEQFKtywKx6sbj+RZ2RnZMaIswwl9nLSvPx73Vq6v3dYqqDCoT2J8HBLpE47eOIAMuShmxuE9Ujm0mciA/htnxc/iY/zK/eIH0Rn+rBQWcSXE1nqa6LOK4O68t3bbekieoJHB9DfCC8L8bSvCEIbq5Wgh5b8UsUIUzHrrd51OPwwrkRvmInrjj3qd0MQ8Uqaj694E0s1FmaXN/g1UW37whWoWijW5fpf8cIz4LS2PWbtB6NBgNKoKCotzZfYMr03Aw4RlbnxNXEgITEjnXXe/gj3KxybsrbdY8zORWEokcTuIv/M3Vr7JDc2OpLCIV3Ht9VJ+PV621VzB7Llv"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]

EXPOSE 22
VOLUME ${GIT_SERVER_PATH}/data

RUN apk add --no-cache \
    wget \
    openssl \
    bash \
    openssh \
    git \
  && wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
  && chmod +x /usr/bin/dumb-init \
  && apk del openssl wget

COPY scripts/*.sh /
COPY scripts/git-shell-commands /etc/skel/git-shell-commands

RUN apk add --no-cache sed \
  && mkdir -p \
    /etc/skel/.ssh \
  && touch /etc/skel/.ssh/authorized_keys \
  && sed -i /etc/ssh/sshd_config \
    -e "s|#HostKey /etc/ssh/|HostKey ${GIT_SERVER_PATH}/data/keys/|g" \
    -e "s/#PasswordAuthentication yes/PasswordAuthentication no/g" \
    -e "s/#AllowAgentForwarding yes/AllowAgentForwarding no/g" \
    -e "s/#AllowTcpForwarding yes/AllowTcpForwarding no/g" \
  && apk del sed \
  && chmod +x \
    /entrypoint.sh \
    /etc/skel/git-shell-commands/* \
    /manage-git.sh \
  && echo 'Git Server' > /etc/motd \
  && mv /manage-git.sh /usr/local/bin/manage-git \
  && manage-git -h

WORKDIR ${GIT_SERVER_PATH}
