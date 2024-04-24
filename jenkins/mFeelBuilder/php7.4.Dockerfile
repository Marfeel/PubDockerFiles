FROM php:7.4.15-cli-buster

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG COMPOSER_VERSION=2.0.9

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}
ARG RUNC_VERSION=1.1.12
ARG LIBSECCOMP_VERSION=2.5.4
ARG PKG_CONFIG_PATH=/lib/x86_64-linux-gnu/pkgconfig

ENV BUILDKIT_DIR=/opt/buildkit
ENV BUILDKITD_FLAGS="--root /tmp/buildkit"
ENV XDG_RUNTIME_DIR=/run/buildkit

COPY ssh_config "${USER_HOME}"/.ssh/config
COPY php7.4.Dockerfile "${USER_HOME}"/Dockerfile

RUN addgroup --gid ${GID} ${GROUP} && \
    adduser -q --no-create-home --disabled-login --disabled-password --home ${USER_HOME} --uid ${UID} --gid ${GID} --gecos "${USER}" --shell /bin/bash ${USER} && \
    chown -R ${UID}:${GID} ${USER_HOME}/.ssh && \
    chown ${UID}:${GID} ${USER_HOME}/

RUN apt-get update && \
    apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gcc \
            git \
            gnupg-agent \
            gperf \
            hub \
            jq \
            libcap2-bin \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libonig-dev \
            libpng-dev libxpm-dev \
            libprotobuf-dev \
            libprotobuf17 \
            libtool \
            libwebp-dev \
            libxml2-dev \
            make \
            procps \
            software-properties-common \
            uidmap \
            unzip \
            vim \
            wget

RUN ssh-keyscan github.com > "${USER_HOME}"/.ssh/known_hosts

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce-cli  docker-compose

RUN curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -fr /tmp/aw*

RUN curl -Ls https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
         -o /usr/local/bin/yq && \
    chmod a+x /usr/local/bin/yq

RUN curl -Ls https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 \
         -o /usr/local/bin/argocd && \
    chmod a+x /usr/local/bin/argocd

RUN curl -Ls https://deb.nodesource.com/setup_14.x | bash && \
         apt-get install -y nodejs

RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

RUN docker-php-ext-install pdo pdo_mysql soap gd bcmath mbstring pcntl

RUN curl -Ls https://getcomposer.org/download/2.0.9/composer.phar -o /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer

RUN : \
    && apt remove -y runc \
    && apt remove -y --allow-remove-essential libseccomp2 \
    && wget https://go.dev/dl/go1.21.9.linux-amd64.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf go1.21.9.linux-amd64.tar.gz \
    && export PATH=$PATH:/usr/local/go/bin \
    && go version \
    && export GOPATH=/tmp/go \
    && mkdir -p /tmp/go/src/github.com \
    && mkdir -p /tmp/go/src/github.com/opencontainers \
    && mkdir -p /tmp/go/src/github.com/seccomp \
    && cd /tmp/go/src/github.com/seccomp \
    && wget https://github.com/seccomp/libseccomp/releases/download/v${LIBSECCOMP_VERSION}/libseccomp-${LIBSECCOMP_VERSION}.tar.gz \
    && tar -xzf libseccomp-${LIBSECCOMP_VERSION}.tar.gz \
    && cd /tmp/go/src/github.com/seccomp/libseccomp-${LIBSECCOMP_VERSION} \
    && ./configure --libdir /lib/x86_64-linux-gnu \
    && make "[V=0|1]" \
    && make install \
    && cd /tmp/go/src/github.com/opencontainers \
    && git clone https://github.com/opencontainers/runc \
    && cd /tmp/go/src/github.com/opencontainers/runc \
    && git checkout v${RUNC_VERSION} \
    && make \
    && make vendor \
    && make install \
    && :

RUN : \
    && mkdir -p ${XDG_RUNTIME_DIR} \
    && chown ${UID}:${GID} ${XDG_RUNTIME_DIR} \
    && chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap \
    && setcap cap_setuid=ep /usr/bin/newuidmap \
    && setcap cap_setgid=ep /usr/bin/newgidmap \
    && :

RUN : \
    && mkdir -p ${BUILDKIT_DIR} \
    && wget -O /tmp/buildkit.tar.gz https://github.com/moby/buildkit/releases/download/v0.13.1/buildkit-v0.13.1.linux-amd64.tar.gz \
    && tar -xzvf /tmp/buildkit.tar.gz -C ${BUILDKIT_DIR} --strip-components=1 bin/buildctl bin/buildkitd \
    && wget -O /tmp/rootlesskit.tar.gz https://github.com/rootless-containers/rootlesskit/releases/download/v2.0.2/rootlesskit-x86_64.tar.gz \
    && tar -xzvf /tmp/rootlesskit.tar.gz -C ${BUILDKIT_DIR} \
    && :

COPY ./subuid /etc/subuid
COPY ./subgid /etc/subgid
COPY --chmod=0775 ./buildctl-daemonless.sh ${BUILDKIT_DIR}/buildctl-daemonless.sh

USER ${USER}

CMD ["/bin/bash"]
