FROM maven:3.6.3-jdk-11

ARG YQ_VERSION=3.3.0
ARG ARGOCD_VERSION=1.5.2
ARG GRAALVM_VERSION=19.3.1

ARG USER=jenkins
ARG GROUP=docker
ARG UID=1004
ARG GID=999
ARG USER_HOME=/home/${USER}

ENV MAVEN_CONFIG=${USER_HOME}/.m2
ENV MAVEN_HOME=${USER_HOME}
ENV GRAALVM_HOME=/usr/share/graalvm

COPY Dockerfile "${USER_HOME}"/Dockerfile

RUN apt-get clean && \
    apt-get update && \
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
            jq \
            build-essential \
            libssl-dev \
            libreadline-dev \
            libcurl4-openssl-dev \
            software-properties-common \
            unzip \
            vim \
            ruby-full \
            xvfb gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
            libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
            libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
            libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
            libxtst6 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils \
            wget

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

RUN ~/.rbenv/bin/rbenv install 2.7.6
RUN ~/.rbenv/bin/rbenv global 2.7.6

CMD ["/bin/bash"]
