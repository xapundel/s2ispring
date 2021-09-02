#FROM    registry.access.redhat.com/ubi8/openjdk-11 AS builder
FROM image-registry.openshift-image-registry.svc:5000/openshift/openjdk:11.0.3-jdk AS builder
MAINTAINER Igor Khapov 
LABEL Description="springDemoApp" Version="1.0.0"

WORKDIR /usr/src
COPY    . .


SHELL   ["/bin/bash", "-c"]
RUN     set -euo pipefail; \
        ./gradlew --stacktrace --info --console=plain build; \
        APP_VER=$(grep '^version' build.gradle | cut -d "'" -f2); \
        cd build/libs/ && mv springDemoApp-$APP_VER.jar app.jar

#-----------------------------------------------------------------------------------------------------------------------------------
#FROM    registry.access.redhat.com/ubi8/openjdk-11
FROM image-registry.openshift-image-registry.svc:5000/openshift/openjdk:11.0.3-jre
# Setup package manager, https://manpages.debian.org/buster/debconf-doc/debconf.7.en.html
ARG     DEBIAN_FRONTEND=noninteractive

COPY    --from=builder /usr/src/build/libs/app.jar /opt

WORKDIR /opt
CMD     java -jar /opt/app.jar

EXPOSE	8080/tcp

RUN sleep 20

#docker build -t springdemoapp .
#docker run -it --rm -p 8080:8080 springdemoapp
