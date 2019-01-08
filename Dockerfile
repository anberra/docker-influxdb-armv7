FROM balenalib/armv7hf-debian

# author
MAINTAINER andres.bermejo@gmail.com

# extra metadata
LABEL version="1"
LABEL description="Image with InfluxDB for armv7"

# variables
ARG DISTRO="stretch"

# cross-build to build arm containers on dockerhub
RUN [ "cross-build-start" ]

# install basics
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        curl \
        libfontconfig 

# deploy
RUN     curl -sL https://repos.influxdata.com/influxdb.key | apt-key add - && \
        printf "deb https://repos.influxdata.com/debian stretch stable" > /etc/apt/sources.list.d/influxdb.list

RUN     apt-get install -y \
        influxdb \
        --no-install-recommends && \
        rm -rf /var/lib/apt/lists/*

# timezone
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# cross-build to build arm containers on dockerhub
RUN [ "cross-build-end" ]

EXPOSE 8086

VOLUME /var/lib/influxdb

COPY entrypoint.sh /entrypoint.sh
COPY init-influxdb.sh /init-influxdb.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
