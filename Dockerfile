#FROM    registry.access.redhat.com/ubi8/openjdk-11 AS builder
#FROM image-registry.openshift-image-registry.svc:5000/openshift/openjdk:11.0.3-jdk AS builder
FROM openjdk-11:1.10-1
MAINTAINER Igor Khapov 
LABEL Description="springDemoApp" Version="1.0.0"

WORKDIR /usr/src
COPY    . .

USER root

SHELL   ["/bin/bash", "-c"]
RUN     set -euo pipefail; \
        ./gradlew --stacktrace --info --console=plain build; \
        APP_VER=$(grep '^version' build.gradle | cut -d "'" -f2); \
        cd build/libs/ && mv springDemoApp-$APP_VER.jar /opt/app.jar   

ARG     DEBIAN_FRONTEND=noninteractive

WORKDIR /opt
CMD     java -jar /opt/app.jar

EXPOSE	8080/tcp

