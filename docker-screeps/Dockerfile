FROM alpine:latest

MAINTAINER Leo Przybylski <r351574nc3 at gmail.com>

ENV STEEM_NAME "NO_USER_SPECIFIED"
ENV STEEM_WIF  "NO_WIF_SPECIFIED"

RUN apk update \
    && apk add --no-progress --no-cache \
        nodejs \
        util-linux \
        build-base \
        python \
        python3 \
    && npm install -g parcel-bundler

RUN npm install screeps 

CMD ["npx", "screeps", "init"]