FROM openjdk:8-jdk-alpine as builder


RUN apk update \
    && apk add maven

WORKDIR /maven

ONBUILD COPY . /maven
ONBUILD RUN mvn install