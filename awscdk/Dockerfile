from node:alpine

ENV AWS_REGION us-east-1

RUN apk update \\
    && apk add --no-cache ca-certificates\
        bash \
        curl \
        python3 \
    && rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip \
    && pip3 install awscli \
    && npm install -g aws-cdk

RUN COPY ./credentials /home/root/.aws/credentials
