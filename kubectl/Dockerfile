FROM ubuntu:20.04

LABEL maintainer="Marfeel SysOps <ops@marfeel.com>"

ENV K8S_VERSION=1.18.3
ENV HELM_VERSION=3.5.4
ENV GOLANG_VERSION=1.14
ENV DEBIAN_FRONTEND=noninteractive 
ENV SOPS_VERSION=3.5.0
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/lib/go-${GOLANG_VERSION}/bin:$PATH

RUN apt-get update && \
    apt-get install -y curl wget git gcc software-properties-common


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

ENTRYPOINT ["kubectl"]
CMD ["help"]