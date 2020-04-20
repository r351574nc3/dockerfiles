FROM openjdk:12-jdk-alpine as builder


RUN apk update \
    && apk add maven

WORKDIR /maven

ONBUILD COPY . /maven
ONBUILD RUN mvn install