FROM balenalib/armv7hf-debian

# author
MAINTAINER andres.bermejo@gmail.com

# extra metadata
LABEL version="1"
LABEL description="Image with InfluxDB for armv7"
LABEL GitHub="https://github.com/anberra/docker-influxdb-armv7"

# variables
ARG DISTRO="stretch"

# cross-build to build arm containers on dockerhub
RUN [ "cross-build-start" ]

# install basics
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        wget 


# add influxdata repo
RUN     wget https://repos.influxdata.com/influxdb.key && \
        apt-key add influxdb.key && \
        /bin/bash -c 'echo "deb https://repos.influxdata.com/debian $DISTRO stable"' | tee "/etc/apt/sources.list.d/influxdb.list"

# deploy
RUN     apt-get update && apt-get install -y \
        influxdb \
        --no-install-recommends && \
        rm -rf /var/lib/apt/lists/*

# timezone
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# cross-build to build arm containers on dockerhub
RUN [ "cross-build-end" ]

EXPOSE 8086

COPY entrypoint.sh /entrypoint.sh
COPY init-influxdb.sh /init-influxdb.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
