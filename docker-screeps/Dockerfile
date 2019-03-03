FROM alpine:latest

MAINTAINER Leo Przybylski <r351574nc3 at gmail.com>

ENV STEAM_API_KEY "NOT_SPECIFIED"

RUN apk update \
    && apk add --no-progress --no-cache \
        nodejs \
        nodejs-npm \
        util-linux \
        build-base \
        python \
        python3 \
    && rm -rf /var/cache/apk/* \
    && adduser -S -g 'Screeps Server' -h '/screeps' screeps

USER screeps
WORKDIR /screeps
EXPOSE 21025

RUN chmod 777 /screeps

ADD . /screeps

RUN npm install screeps


ENTRYPOINT ["/screeps/docker-entrypoint.sh"]
CMD ["npx", "screeps", "start"]