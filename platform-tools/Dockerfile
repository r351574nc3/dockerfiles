FROM golang:1.13-alpine as goapps

ENV CGO_ENABLED=0\
    GOOS=linux\
    GOPRIVATE=github.com/InVisionApp/*


RUN apk update \\
    && apk add --no-cache ca-certificates git \
    && rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/InVisionApp

COPY ./.netrc /root/

# Add rest of source code

RUN go get github.com/InVisionApp/fleet \
    && go get github.com/InVisionApp/hound

WORKDIR /go/src/github.com/InVisionApp/fleet
    
RUN GOOS=linux CGO_ENABLED=0 go build -a -installsuffix cgo -o fleet .

WORKDIR /go/src/github.com/InVisionApp/hound
    
RUN GOOS=linux CGO_ENABLED=0 go build -a -installsuffix cgo -o hound .

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

COPY --from=goapps /go/src/github.com/InVisionApp/hound/hound /usr/local/bin/hound
COPY --from=goapps /go/src/github.com/InVisionApp/fleet/fleet /usr/local/bin/fleet
COPY --from=goapps /go/src/github.com/InVisionApp/fleet/fleet_run.sh /usr/local/bin/fleet_run.sh

VOLUME [ "/workspace" ]