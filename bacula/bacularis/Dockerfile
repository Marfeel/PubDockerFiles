FROM marfeel/bacula-base:13.0.0-4

LABEL maintainer="ops@marfeel.com"


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata sudo joe wget gpg systemd

RUN apt-get -y install php-common php-bcmath php-curl php-xml php-json php-ldap php-mysqlnd php-pdo php-pgsql php-intl php-fpm

##### BACULARIS INSTALL

RUN wget -qO- https://pkgs.bacularis.app/bacularis.pub | gpg --dearmor > /usr/share/keyrings/bacularis-archive-keyring.gpg 

COPY bacularis.list /etc/apt/sources.list.d/baculum.list

RUN apt-get update && \ 
    apt -y install bacularis bacularis-apache2
    
RUN a2enmod rewrite && \
    a2enmod proxy_fcgi && \
    a2enconf php8.1-fpm && \
    a2ensite bacularis

COPY sudoers-bacularis /etc/sudoers.d/sudoers-bacularis

RUN mkdir -p /run/php-fpm/ && \
    service php8.1-fpm start && \
    systemctl enable php8.1-fpm

RUN service php8.1-fpm start
    
        
CMD ["apache2ctl", "-D", "FOREGROUND"]


EXPOSE 9097