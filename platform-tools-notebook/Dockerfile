FROM golang:1.13-alpine as goapps

ENV CGO_ENABLED=0\
    GOOS=linux\

RUN apk update \\
    && apk add --no-cache ca-certificates\
        git \
        gcc \
        g++ \
        pkgconfig \
        linux-headers \
        zeromq \
        zeromq-dev \
    && rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/InVisionApp

COPY ./.netrc /root/

# Add rest of source code

FROM alpine

LABEL maintainer="Leo Przybylski <r351574nc3 at gmail.com>"

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="1000"

ENV CGO_ENABLED=1\
    DOCKERMACHINE_VERSION=0.16.2\
    GOOS=linux\
    NB_USER=$NB_USER\
    NB_UID=$NB_UID\
    NB_GID=$NB_GID\
    AWS_REGION=us-east-1\
    GOPATH=/go\
    GOPHERNOTESPATH=/home/$NB_USER/.local/share/jupyter/kernels/gophernotes/

RUN apk update \
    && apk upgrade --update-cache --available \
    && apk --no-cache \
        --arch=x86_64 add \
        bash \
        bind-tools \
        build-base \
        ca-certificates \
        curl \
        dnsmasq \
        jq \
        python3 \
        python3-dev\
        terraform \
        git \
        linux-headers \
        py3-zmq \
        tar \
        zeromq \
        zeromq-dev \
    && pip3 install --upgrade pip \
    && pip3 install awscli jupyter jupyterlab sgqlc\
    && curl -sSL https://github.com/docker/machine/releases/download/v${DOCKERMACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine \
    && chmod +x /usr/local/bin/docker-machine \
    && rm -rf /var/cache/apk/*

COPY start-notebook.sh /usr/local/bin
COPY start-singleuser.sh /usr/local/bin

RUN apk --update-cache --allow-untrusted \
    --repository http://dl-4.alpinelinux.org/alpine/edge/community \
    --arch=x86_64 add \
    go

RUN addgroup -S -g $NB_GID $NB_USER \
    && adduser --system $NB_USER --uid $NB_UID --ingroup $NB_USER \
    && mkdir -p $GOPHERNOTESPATH \
    && mkdir -p $GOPATH \
    && chown -R $NB_USER:$NB_USER /go \
    && chown -R $NB_USER:$NB_USER /home/$NB_USER/.local

USER $NB_UID

RUN GOPATH=/go go get github.com/gopherdata/gophernotes \
    && cd /go/src/github.com/gopherdata/gophernotes \
    && GOPATH=/go GO111MODULE=on go install .

RUN cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* $GOPHERNOTESPATH\
    && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < ${GOPHERNOTESPATH}kernel.json.in > ${GOPHERNOTESPATH}kernel.json

RUN mkdir /usr/local/etc/dnsmasq.d
 
COPY ./credentials /home/$NB_USER/.aws/credentials

WORKDIR /workspace
VOLUME [ "/workspace" ]
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start-notebook.sh"]