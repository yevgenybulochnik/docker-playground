FROM ubuntu:16.04

WORKDIR /config

ADD ./config /config

RUN apt update -y 
RUN apt install -y \
    curl \
    debconf-utils

RUN /config/wp_config.sh

EXPOSE 80
EXPOSE 3306

ENTRYPOINT ["/bin/bash", "/config/start.sh"]
