from node:alpine

ARG AWS_USER="node"

ENV AWS_REGION us-west-2\
    AWS_USER=$AWS_USER\
    AWS_REGION=us-west-2

RUN apk update \
    && apk add --no-cache ca-certificates\
        bash \
        curl \
        python3 \
    && rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip \
    && pip3 install awscli \
    && npm install -g aws-cdk

USER $AWS_USER

COPY ./credentials /home/root/.aws/credentials

WORKDIR /workspace
