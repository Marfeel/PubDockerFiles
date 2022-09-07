FROM mysql:8.0.28

ADD https://dev.mysql.com/get/mysql-apt-config_0.8.23-1_all.deb /root/mysql-apt-config_0.8.23-1_all.deb

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29 && \
    apt update && \
    apt install -y lsb-release wget locales && \
    dpkg -i /root/mysql-apt-config_0.8.23-1_all.deb && \
    apt update && \
    apt install -y mysql-shell=8.0.30-1debian10 && \
    rm -rf /var/lib/apt/lists/*
