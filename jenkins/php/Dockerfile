FROM ubuntu:18.04

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y \
    sudo git subversion vim curl dnsutils iputils-ping build-essential \
    mysql-client php php-xml php-mysql php-mbstring unzip apt-transport-https \
    locales lsof ruby-dev software-properties-common language-pack-en-base zlib1g-dev libicu-dev g++ php-xdebug && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get update && \
    apt-get install -y \
    php5.6-cli php5.6-fpm php5.6-xml php5.6-mysql php5.6-mbstring \
    php7.0-cli php7.0-fpm php7.0-xml php7.0-mysql php7.0-mbstring \
    php7.1-cli php7.1-fpm php7.1-xml php7.1-mysql php7.1-mbstring php7.1-bz2 \
    php7.2-cli php7.2-fpm php7.2-xml php7.2-mysql php7.2-mbstring php7.2-bz2 \
    nodejs groovy openjdk-8-jdk-headless libxml2 libxml2-dev libssl-dev \
    libbz2-dev libcurl4-openssl-dev libmcrypt-dev libedit-dev libreadline-dev libxslt-dev zlib1g-dev && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/php/{5.6,7.0,7.1,7.2}/mods-available/xdebug.ini && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

RUN \
	git clone https://github.com/sass/sassc.git --branch 3.2.1 --depth 1 /usr/local/lib/sassc && \
	git clone https://github.com/sass/libsass.git --branch 3.2.1 --depth 1 /usr/local/lib/libsass && \
	echo 'SASS_LIBSASS_PATH="/usr/local/lib/libsass"' >> /etc/environment && \
	export SASS_LIBSASS_PATH="/usr/local/lib/libsass" && \
	make -C /usr/local/lib/sassc/ && \
	ln -s /usr/local/lib/sassc/bin/sassc /usr/local/bin/sassc

RUN \
	npm -g config set user root && \
	npm install -g gulp && \
	npm -g install node-sass && \
	gem install scss_lint

RUN \
	curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
	php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	rm -fr /tmp/composer-setup.php && \
	curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew && \
	chmod +x phpbrew && mv phpbrew /usr/local/bin/phpbrew

RUN groupadd -g 1004 jenkins && \
	useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins && \
	mkdir -p /home/jenkins/.ssh/ && chown -R jenkins:jenkins /home/jenkins/.ssh/ && \
    mkdir -p /usr/src/MarfeelPressJenkinsTesting/ && \
    chown -R jenkins:jenkins /usr/src/MarfeelPressJenkinsTesting/ /usr/src && \
    mkdir -p /home/jenkins/.groovy && chown -R jenkins:jenkins /home/jenkins/.groovy

USER jenkins

RUN \
	phpbrew init && phpbrew update --old && \
	phpbrew install 5.3.29 -openssl +mysql +json +ctype +hash +xml +mbstring && \
	sed -i -r -e 's/short_open_tag = Off/short_open_tag = On/g'  /home/jenkins/.phpbrew/php/php-5.3.29/etc/php.ini && \
	phpbrew install 5.4.45 -openssl +mysql +json +ctype +hash +xml +mbstring && \
	sed -i -r -e 's/short_open_tag = Off/short_open_tag = On/g'  /home/jenkins/.phpbrew/php/php-5.4.45/etc/php.ini && \
	phpbrew install 5.5.38 -openssl +mysql +json +ctype +hash +xml +mbstring && \
	sed -i -r -e 's/short_open_tag = Off/short_open_tag = On/g'  /home/jenkins/.phpbrew/php/php-5.5.38/etc/php.ini && \
	rm -rf /etc/php/{5.6,7.0,7.1,7.2}/mods-available/xdebug.ini

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
