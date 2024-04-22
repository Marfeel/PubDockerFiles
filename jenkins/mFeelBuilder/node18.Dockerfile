FROM maven:3.8.3-eclipse-temurin-17

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG RUBY_VERSION=2.7.6
ARG RUBY_BUNDLER_VERSION=2.3.26
ARG GRAALVM_VERSION=21.3.0

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}

ENV BUILDKIT_DIR=/opt/buildkit
ENV BUILDKITD_FLAGS="--root /tmp/buildkit"
ENV GRAALVM_HOME=/usr/share/graalvm
ENV MAVEN_CONFIG=${USER_HOME}/.m2
ENV MAVEN_HOME=${USER_HOME}
ENV RBENV_HOME=${USER_HOME}/rbenv
ENV XDG_RUNTIME_DIR=/run/buildkit

RUN mkdir -p "${USER_HOME}"/.ssh/ && ssh-keyscan github.com > "${USER_HOME}"/.ssh/known_hosts

RUN addgroup --gid ${GID} ${GROUP} && \
    adduser -q --no-create-home --disabled-login --disabled-password --home ${USER_HOME} --uid ${UID} --gid ${GID} --gecos "${USER}" --shell /bin/bash ${USER} && \
    chown ${UID}:${GID} ${USER_HOME}/

RUN apt-get update && \
    apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            dirmngr \
            gcc \
            git \
            gnupg2 \
            gnupg-agent \
            hub \
            libcap2-bin \
            runc \
            jq \
            build-essential \
            zlib1g-dev \
            libssl-dev \
            libreadline-dev \
            libcurl4-openssl-dev \
            software-properties-common \
            uidmap \
            unzip \
            vim \
            xvfb gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
            libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
            libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
            libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
            libxtst6 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils \
            wget

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

RUN curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -fr /tmp/aw*

RUN curl -Ls https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
         -o /usr/local/bin/yq && \
    chmod a+x /usr/local/bin/yq

RUN curl -Ls https://deb.nodesource.com/setup_18.x | bash && \
    apt-get install nodejs

RUN mkdir -p ${GRAALVM_HOME} && \
    curl -Ls https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java17-linux-amd64-${GRAALVM_VERSION}.tar.gz \
         -o /tmp/graalvm.tar.gz && \
    tar -zxf /tmp/graalvm.tar.gz -C "${GRAALVM_HOME}" --strip-components=1 && \
    rm -fr /tmp/graalvm.tar.gz

RUN curl -Ls https://cache.ruby-lang.org/pub/ruby/2.7/ruby-${RUBY_VERSION}.tar.gz | tar -xz -C /usr/src && \
    cd /usr/src/ruby-${RUBY_VERSION} && \
    ./configure && \
    make && \
    make install

RUN gem install bundler -v ${RUBY_BUNDLER_VERSION}

COPY ssh_config "${USER_HOME}"/.ssh/config

RUN chown -R ${UID}:${GID} ${USER_HOME}/.ssh

COPY node18.Dockerfile /Dockerfile

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
