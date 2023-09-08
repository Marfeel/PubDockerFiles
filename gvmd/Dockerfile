FROM greenbone/gvmd:22.8.0

# Update package lists and install necessary packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ssmtp \
        rsync \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pipx and greenbone-feed-sync using pipx
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install greenbone-feed-sync
