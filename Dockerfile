# build 
FROM maven:3.6-slim AS builder

COPY pom.xml /app/
COPY src /app/src/

WORKDIR /app
RUN mvn --batch-mode --define java.net.useSystemProxies=true package

# image
FROM jetty:9.4-jre8-alpine
MAINTAINER D.Ducatel

USER root

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --no-cache -U add graphviz font-noto-cjk

USER jetty

ENV GRAPHVIZ_DOT=/usr/bin/dot

ARG BASE_URL=ROOT
COPY --from=builder /app/target/plantuml.war /var/lib/jetty/webapps/$BASE_URL.war
