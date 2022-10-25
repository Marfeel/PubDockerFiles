FROM bacula-base:latest

MAINTAINER francesc.sanjuan@marfeel.com

RUN wget -qO - http://bacula.org/downloads/baculum/baculum.pub | apt-key add -

COPY baculum.list /etc/apt/sources.list.d/baculum.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
	sudo \
	baculum-common \
	baculum-web \
	baculum-web-apache2 \
  baculum-api \
  baculum-api-apache2

COPY sudoers-baculum /etc/sudoers.d/sudoers-baculum 

RUN sed -i 's%;date.timezone =%date.timezone = UTC%' /etc/php/7.2/apache2/php.ini

RUN chown -R www-data:bacula /opt/bacula/working /opt/bacula/etc \
  && chmod -R g+rwx /opt/bacula/working /opt/bacula/etc


RUN a2ensite baculum-api && \
    a2ensite baculum-web && \
    a2enmod rewrite

EXPOSE 9095/tcp 9096/tcp

# ENTRYPOINT [""]

CMD ["apache2ctl", "-D", "FOREGROUND"]

