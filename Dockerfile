FROM    registry.access.redhat.com/ubi8/openjdk-11 AS builder
MAINTAINER Igor Khapov 
LABEL Description="springDemoApp" Version="1.0.0"

WORKDIR /usr/src
COPY    . .

SHELL   ["/bin/bash", "-c"]
RUN     set -euo pipefail; \
        ./gradlew --stacktrace --info --console=plain build; \
        APP_VER=$(grep '^version' build.gradle | cut -d "'" -f2); \
        cd build/libs/

#-----------------------------------------------------------------------------------------------------------------------------------
FROM    registry.access.redhat.com/ubi8/openjdk-11

# Setup package manager, https://manpages.debian.org/buster/debconf-doc/debconf.7.en.html
ARG     DEBIAN_FRONTEND=noninteractive

COPY    --from=builder /usr/src/build/libs/springDemoApp-$APP_VER.jar /opt
RUN     ln -s springDemoApp-$APP_VER.jar app.jar

WORKDIR /opt
CMD     java -jar /opt/app.jar

EXPOSE	8080/tcp

#docker build -t springdemoapp .
#docker run -it --rm -p 8080:8080 springdemoapp
