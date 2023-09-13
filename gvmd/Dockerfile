FROM greenbone/gvmd:22.8.0

RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ssmtp \
        rsync \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN :\
    && python3 -m pip install --no-cache-dir install \
        greenbone-feed-sync \
    && :
