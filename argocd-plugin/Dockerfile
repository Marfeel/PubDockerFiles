FROM ubuntu:22.04

LABEL maintainer="Marfeel SysOps <ops@marfeel.com>"

ARG HELM_SOPS_VER="20220419-3"
ARG HELM_VERSION="v3.10.1"
ARG YQ_VERSION="v4.30.7"
ARG YQ_BINARY="yq_linux_amd64"

RUN export DEBIAN_FRONTEND=noninteractive && \
    export TZ=Etc/UTC && \
    apt update && apt install -y wget awscli curl jq && \
    wget -q https://github.com/camptocamp/helm-sops/releases/download/${HELM_SOPS_VER}/helm-sops_${HELM_SOPS_VER}_linux_amd64.tar.gz && \
    tar zxf helm-sops_${HELM_SOPS_VER}_linux_amd64.tar.gz && \
    mkdir -p /usr/local/bin && \
    cp helm-sops /usr/local/bin/helm && \
    wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    cp linux-amd64/helm /usr/local/bin/_helm && \
    mkdir -p /home/argocd/cmp-server/config && \
    chown -R 999 /home/argocd && \
    wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
WORKDIR /home/argocd/cmp-server/config/

USER 999
