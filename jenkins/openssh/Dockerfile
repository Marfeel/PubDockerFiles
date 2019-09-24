FROM ubuntu:18.04

RUN \
  apt-get -y update && \
  apt-get -y install \
    openssh-client \
    make \
    pssh && \
  rm -rf /var/lib/apt/lists/*

RUN groupadd -g 999 docker \
  && useradd -d /home/jenkins -m -r -u 1004 -g docker jenkins \
  && install -g 999 -o 1004 -d -m 0750 /home/jenkins/.ssh

COPY --chown=1004:999 ssh_config /home/jenkins/.ssh/config

USER 1004:999
