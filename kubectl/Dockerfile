FROM ubuntu:20.04

LABEL maintainer="Marfeel SysOps <ops@marfeel.com>"

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}

ENV K8S_VERSION=1.18.3
ENV HELM_VERSION=3.5.4
ENV GOLANG_VERSION=1.14
ENV DEBIAN_FRONTEND=noninteractive
ENV SOPS_VERSION=3.5.0
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/lib/go-${GOLANG_VERSION}/bin:$PATH

COPY ssh_config "${USER_HOME}"/.ssh/config

RUN apt-get update && \
    apt-get install -y curl wget git gcc software-properties-common python3-pip

RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y golang-${GOLANG_VERSION}-go

RUN curl -Ls https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb -o /tmp/sops.deb && \
    dpkg -i /tmp/sops.deb && \
    rm -fr /tmp/sops.deb

RUN curl -Ls https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zx -f - linux-amd64/helm --strip-components=1 && \
    mv helm /usr/local/bin/ && \
    helm plugin install https://github.com/zendesk/helm-secrets

RUN curl -Ls https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    echo 'source <(kubectl completion bash)' >> ~/.bashrc && \
    echo 'alias k=kubectl' >>~/.bashrc && \
    echo 'complete -F __start_kubectl k' >>~/.bashrc

RUN set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew && \
    echo "export PATH=${KREW_ROOT:-$HOME/.krew}/bin:$PATH" >> $HOME/.bashrc && \
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && \
    kubectl krew install slice

RUN pip3 install boto3 certbot

USER ${USER}

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
