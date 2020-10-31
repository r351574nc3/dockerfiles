FROM node:10.6-alpine

VOLUME /bot

WORKDIR /bot

RUN npm install -g yo generator-hubot \
    && mkdir -p /root/.config/insight-nodejs/ \
    && touch /root/.config/insight-nodejs/insight-yo.json \
    && chmod -R 777 /root/.config/insight-nodejs/insight-yo.json

CMD ["yo", "hubot"]