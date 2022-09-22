FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="UTC"
ARG JMETER_VERSION="5.5"

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        curl \
        git \
        libssl-dev \
        libxml2-dev \
        libltdl-dev \
        openjdk-18-jdk \
        openssl \
        pkg-config \
        vim

RUN mkdir /opt/apache-jmeter && \
    mkdir /workspace && \
    curl -Ls https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz | tar -zx -C /opt/apache-jmeter/ --strip-components=1

ENV HEAP="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"

ENTRYPOINT ["/opt/apache-jmeter/bin/jmeter"]
CMD ["-n", "-t", "/workspace/test.jmx", "-l", "/workspace/test.jtl"]
