FROM openjdk:11-alpine as builder


RUN apk update \
    && apk add maven

WORKDIR /maven

COPY . /maven

RUN mvn install