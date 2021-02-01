FROM ubuntu:20.04

ENV CLICKHOSE_PROXY_VERSION=1.14.0

RUN apt-get update && apt-get install -y curl

RUN curl -Ls https://github.com/Vertamedia/chproxy/releases/download/v1.14.0/chproxy-linux-amd64-v1.14.0.tar.gz | tar -zx -C /usr/local/bin

ENTRYPOINT ["chproxy"]

CMD ["-config=/config.yml"]
