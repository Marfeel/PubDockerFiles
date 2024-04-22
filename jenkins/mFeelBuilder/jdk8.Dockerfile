FROM maven:3.6.3-jdk-8

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG GRAALVM_VERSION=19.3.1

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
ENV XDG_RUNTIME_DIR=/run/buildkit

COPY ssh_config "${USER_HOME}"/.ssh/config
COPY jdk8.Dockerfile "${USER_HOME}"/Dockerfile

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
            libcap2-bin \
            runc \
            jq \
            software-properties-common \
            uidmap \
            unzip \
            vim \
            wget

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce-cli docker-compose

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
    curl -Ls https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz \
         -o /tmp/graalvm.tar.gz && \
    tar -zxf /tmp/graalvm.tar.gz -C "${GRAALVM_HOME}" --strip-components=1 && \
    rm -fr /tmp/graalvm.tar.gz

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
