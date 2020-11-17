FROM ubuntu:18.04
ARG TF_VERSION="0.12.24"

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update && \
    apt-get install -y curl wget git gcc software-properties-common bash-completion unzip jq vim

RUN curl -L https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz -o /tmp/hub-linux-amd64-2.14.2.tgz && \
    tar zxvf /tmp/hub-linux-amd64-2.14.2.tgz -C /tmp/ && \
    bash /tmp/hub-linux-amd64-2.14.2/install && \
    rm -rf /tmp/hub-linux-amd64-2.14.2.tgz

RUN \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

RUN groupadd -g 1004 jenkins && \
    useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins

RUN \
    mkdir -p /home/jenkins/.ssh/ && \
    mkdir -p /home/jenkins/.terraform.d/ && \
    chown -R jenkins:jenkins /home/jenkins/.terraform.d/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/


RUN \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/

USER jenkins
