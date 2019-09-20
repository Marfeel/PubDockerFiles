FROM ubuntu:18.04

RUN \
  apt-get -y update && \
  apt-get -y install openssh-client make

RUN groupadd -g 999 docker \
  && useradd -d /home/jenkins -m -r -u 1004 -g docker jenkins

COPY --chown=1004:999 ssh_config /etc/ssh/ssh_config

USER jenkins 1004:999
