FROM balenalib/armv7hf-debian

# author
MAINTAINER andres.bermejo@gmail.com

# extra metadata
LABEL version="1"
LABEL description="Image with InfluxDB for armv7"

# variables
ARG DISTRO="stretch"

# env
ENV GRAFANA_URL="https://dl.grafana.com/oss/release/$DEB_FILE" \
    PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning" \
    GF_PATHS_DEB="/depot"

# cross-build to build arm containers on dockerhub
RUN [ "cross-build-start" ]

# install basics
RUN apt-get update && apt-get install -y \
        curl \
        libfontconfig 


# deploy
RUN curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add - source /etc/os-release && \
    echo "deb https://repos.influxdata.com/debian ${DISTRO} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list && \
    apt-get install -y \
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
