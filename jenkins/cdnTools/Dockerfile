FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg > /tmp/key && \
    apt-key add /tmp/key && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list

RUN apt update && \
    apt dist-upgrade -y  && \
    apt install -y \
        python3.7 \
        python3-pip \
        git \
        curl \
        jq \
        python3-requests \
        rsync \
        ansible \
        docker-ce && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install jmespath pyyaml ansible-lint jsonschema

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

RUN groupadd -g 1004 jenkins && \
    useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins

RUN \
    mkdir -p /home/jenkins/.ssh/ && \
    mkdir -p /mediagroup && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

USER jenkins
