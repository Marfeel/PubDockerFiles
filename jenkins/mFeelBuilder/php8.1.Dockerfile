FROM php:8.1.10-cli-buster

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG COMPOSER_VERSION=2.4.2

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}

COPY ssh_config "${USER_HOME}"/.ssh/config
COPY php8.1.Dockerfile "${USER_HOME}"/Dockerfile

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
            hub \
            jq \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libonig-dev \
            libpng-dev libxpm-dev \
            libprotobuf-dev \
            libprotobuf17 \
            libprotobuf17 \
            libtool \
            libwebp-dev \
            libxml2-dev \
            make \
            procps \
            software-properties-common \
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

RUN curl -Ls https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer

USER ${USER}

CMD ["/bin/bash"]
