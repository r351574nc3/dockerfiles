FROM alpine:edge

LABEL maintainer="Leo Przybylski <r351574nc3@gmail.com>"

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="1000"

ENV NB_USER=$NB_USER\
    NB_UID=$NB_UID\
    NB_GID=$NB_GID\
    JUPYTER_ENABLE_LAB=1\
    PORT=8888

RUN apk update \
    && apk upgrade --update-cache --available \
    && apk --no-cache \
        --arch=x86_64 add \
        bash \
        build-base \
        ca-certificates \
        curl \
        python3 \
        python3-dev\
        git \
        linux-headers \
        py3-pyzmq \
        zeromq \
        zeromq-dev \
    && pip3 install --upgrade pip \
    && pip3 install jupyter jupyterlab \
    && rm -rf /var/cache/apk/*

COPY start-notebook.sh /usr/local/bin
COPY start-singleuser.sh /usr/local/bin

RUN mkdir -p /workspace \
    && addgroup -S -g $NB_GID $NB_USER \
    && adduser --system $NB_USER --uid $NB_UID --ingroup $NB_USER \
    && chown -R $NB_USER:$NB_USER /home/$NB_USER /workspace

USER $NB_UID

WORKDIR /workspace
EXPOSE $PORT

CMD ["sh", "-c", "/usr/local/bin/start-notebook.sh --ip=0.0.0.0 --port=$PORT"]