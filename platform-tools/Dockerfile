FROM golang:1.13-alpine as goapps

ENV CGO_ENABLED=0\
    GOOS=linux\

RUN apk update \\
    && apk add --no-cache ca-certificates git \
    && rm -rf /var/cache/apk/*

COPY ./.netrc /root/

# Add rest of source code

from alpine

ENV CGO_ENABLED=0\
    GOOS=linux

COPY ./credentials /root/.aws/credentials

RUN apk update \\
    && apk upgrade --update-cache --available \
    && apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        python \
        py-pip \
        terraform \
        git \
    && pip install awscli \
    && rm -rf /var/cache/apk/*

WORKDIR /workspace
VOLUME [ "/workspace" ]