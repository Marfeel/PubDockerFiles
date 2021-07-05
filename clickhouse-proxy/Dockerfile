FROM ubuntu:20.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV CLICKHOUSE_PROXY_VERSION=1.14.0

RUN apt update && apt install -y make gcc musl-dev git golang-1.16 tzdata wget && \
    ln -s /usr/lib/go-1.16/bin/go /usr/local/bin/go && \
    go get golang.org/x/lint/golint && \
    mkdir -p /go/src/github.com/Vertamedia/chproxy

WORKDIR /go/src/github.com/Vertamedia/chproxy

RUN wget https://github.com/Vertamedia/chproxy/archive/refs/tags/v1.14.0.tar.gz -O /tmp/v1.14.0.tar.gz && \
    tar zxvf /tmp/v1.14.0.tar.gz --strip-components=1 -C /go/src/github.com/Vertamedia/chproxy && \
    make release-build

FROM ubuntu:20.04

COPY --from=build /go/src/github.com/Vertamedia/chproxy/chproxy /chproxy

ENTRYPOINT [ "/chproxy" ]

CMD ["-config=/config.yml"]
