# Nginx docker

 
This Dockerfile builds an image of ubuntu 18.04 with nginx and lua support for
oauth.

  
## Setup information

This repo is connected with dockerhub and a commit in master with trigger an
automatic build with the tag "latest".

#To use in docker-compose.yml context:

```
version '2.2':
services:
  nginx:
    image: marfeel/nginx:1.1
    container_name: nginx01
    volumes:
      - ./conf.d:/etc/nginx/conf.d
      - ./certs:/etc/nginx/certs
      - ./access.lua:/etc/nginx/access.lua
    ports:
      - 80:80
      - 443:443
    networks:
      - esnet
networks:
  esnet:
```

Mountable directories:  
["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Pull image from dockerhub:

docker pull marfeel/nginx
