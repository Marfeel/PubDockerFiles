FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y  \
    nodejs
# Define mountable directories.
VOLUME [ "/etc/node"]

# Define working directory.
WORKDIR /etc/node

# Define default command.
CMD ["/opt/kibanaproxy/kibanaproxy.js -ev --target=http://localhost:9200 --listen=9000 --url=https://esmonitoring.marfeel.com:443"]

# Expose ports.
EXPOSE 9000
#EXPOSE 443
