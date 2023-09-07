FROM greenbone/gvmd:22.8.0

RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ssmtp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :
