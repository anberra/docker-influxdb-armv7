# anberra/influxdb-armv7
Influxdb installed in a balenalib/armv7hf-debian stretch for armv7.

# Description
It is ready to run in a Raspberry Pi, tested in RPI3.

# Usage
It is recommended to add persistence to the container for the database:
```
$ docker volume create influxdb
```
To launch the container:
```
$ docker run \
  -d \
  -p 8086:8086 \
  --name=influxdb \
  --mount type=volume,source=influxdb,destination=/var/lib/influxdb \
  --restart=unless-stopped \
  anberra/influxdb-armv7
```

Dockerfile is ready to run in any x86 CPU whereas Dockerfile.arm is intended to run in a ARMv7 CPU like Raspberry Pi.
