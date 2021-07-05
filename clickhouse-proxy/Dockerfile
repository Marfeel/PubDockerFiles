FROM ubuntu:20.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG CLICKHOUSE_PROXY_VERSION=1.14.0
ARG GOLANG_VERSION=1.16

ENV CLICKHOUSE_PROXY_VERSION=1.14.0
ENV TZ=UTC

RUN apt update && apt install -y make gcc musl-dev git golang-${GOLANG_VERSION} tzdata wget && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/lib/go-${GOLANG_VERSION}/bin/go /usr/local/bin/go && \
    go get golang.org/x/lint/golint && \
    mkdir -p /go/src/github.com/Vertamedia/chproxy

WORKDIR /go/src/github.com/Vertamedia/chproxy

RUN wget https://github.com/Vertamedia/chproxy/archive/refs/tags/v${CLICKHOUSE_PROXY_VERSION}.tar.gz -O /tmp/v${CLICKHOUSE_PROXY_VERSION}.tar.gz && \
    tar zxvf /tmp/v${CLICKHOUSE_PROXY_VERSION}.tar.gz --strip-components=1 -C /go/src/github.com/Vertamedia/chproxy && \
    make release-build

FROM ubuntu:20.04

COPY --from=build /go/src/github.com/Vertamedia/chproxy/chproxy /chproxy

ENTRYPOINT [ "/chproxy" ]

CMD ["-config=/config.yml"]
