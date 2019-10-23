FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y  \
    nginx-extras \
    lua5.3 \
    lua-json \
    lua-sec
# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx", "-g", "daemon off;"]

# Expose ports.
EXPOSE 80
EXPOSE 443
