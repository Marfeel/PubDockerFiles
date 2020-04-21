ARG YQ_DOCKER_TAG=3.3.0

FROM mikefarah/yq:${YQ_DOCKER_TAG} as yq

RUN yq --version


FROM alpine:3.11

ARG DUMB_INIT_VERSION=1.2.2
ARG ARGOCD_VERSION=v1.5.2
ARG user=jenkins
ARG group=docker
ARG uid=1004
# Notice gid 999 is used by ping in Alpine. If changed review th delgroup line in 
# corresponding RUN instruction to prevent removing an important group for the sys!
ARG gid=999
ARG user_home=/home/${user}

COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY entrypoint.sh /
COPY known_hosts "${user_home}"/.ssh/known_hosts
COPY ssh_config "${user_home}"/.ssh/config

RUN getent group ${gid} \
  && delgroup $(getent group ${gid} | cut -d: -f1) \
  && addgroup -g ${gid} ${group} \
  && adduser -h ${user_home} -u ${uid} -G ${group} -s /bin/bash -D ${user} \
  && chown -R ${uid}:${gid} ${user_home}/.ssh \
  && chmod +x /entrypoint.sh /usr/bin/yq

ENTRYPOINT ["/entrypoint.sh"]

RUN apk --update add --no-cache \
    wget \
    openssl \
    bash \
    git \
    openssh-client \
  && wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
  && wget -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64 \
  && chmod +x /usr/bin/dumb-init /usr/local/bin/argocd \
  && apk del wget


USER ${user}

ENV USER=${user}
