from node:alpine

ARG AWS_REGION="us-west-2"
ARG AWS_USER="node"

ENV AWS_REGION=$AWS_REGION\
    AWS_USER=$AWS_USER

RUN apk update \
    && apk add --no-cache ca-certificates\
        bash \
        curl \
        python3 \
    && rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip \
    && pip3 install awscli \
    && npm install -g aws-cdk \
    && mkdir -p /home/$AWS_USER/.aws \
    && chown -R $AWS_USER /home/$AWS_USER/.aws

USER $AWS_USER

WORKDIR /workspace
