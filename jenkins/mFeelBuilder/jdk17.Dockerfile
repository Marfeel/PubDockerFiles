FROM maven:3.8.3-eclipse-temurin-17

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG GRAALVM_VERSION=21.3.0

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}

ENV MAVEN_CONFIG=${USER_HOME}/.m2
ENV MAVEN_HOME=${USER_HOME}
ENV GRAALVM_HOME=/usr/share/graalvm

COPY ssh_config "${USER_HOME}"/.ssh/config
COPY jdk17.Dockerfile "${USER_HOME}"/Dockerfile

RUN ssh-keyscan github.com > "${USER_HOME}"/.ssh/known_hosts
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
            software-properties-common \
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

RUN curl -Ls https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 \
         -o /usr/local/bin/argocd && \
    chmod a+x /usr/local/bin/argocd

RUN curl -Ls https://deb.nodesource.com/setup_14.x | bash && \
         apt-get install nodejs

RUN mkdir -p ${GRAALVM_HOME} && \
    curl -Ls https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java17-linux-amd64-${GRAALVM_VERSION}.tar.gz \
         -o /tmp/graalvm.tar.gz && \
    tar -zxf /tmp/graalvm.tar.gz -C "${GRAALVM_HOME}" --strip-components=1 && \
    rm -fr /tmp/graalvm.tar.gz

USER ${USER}

CMD ["/bin/bash"]
