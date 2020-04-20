FROM golang:1.13-buster

# Install Jupyter Notebook
# `hash -r pip` is a workaround of pip v10 related issue (https://github.com/pypa/pip/issues/5221#issuecomment-382069604)
RUN apt-get update \
    && apt-get install -y \
        libzmq3-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip \
    && hash -r pip \
    && pip3 install -U jupyter jupyterlab \
    && jupyter serverextension enable --py jupyterlab --sys-prefix

# Install lgo Jupyter lab extension to support code formatting.
# Please remove this line if you do not use JupyterLab.
#    && jupyter labextension install @yunabe/lgo_extension \
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && jupyter lab clean \
    && apt-get remove -y nodejs --purge && rm -rf /var/lib/apt/lists/*

# Support UTF-8 filename in Python (https://stackoverflow.com/a/31754469)
ENV LC_CTYPE=C.UTF-8


# Add a non-root user with uid:1000 to follow the convention of mybinder to use this image from mybinder.org.
# https://mybinder.readthedocs.io/en/latest/dockerfile.html
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME /home/${NB_USER}
ENV LGOPATH /lgo
ENV GOPHERNOTESPATH /home/$NB_USER/.local/share/jupyter/kernels/gophernotes/
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    --home ${HOME} \
    ${NB_USER}
RUN mkdir -p $LGOPATH $GOPHERNOTESPATH
RUN chown -R ${NB_USER}:${NB_USER} ${HOME} $GOPATH $LGOPATH ${HOME}/.local
USER ${NB_USER}
WORKDIR ${HOME}

# Fetch lgo repository
#RUN go get github.com/yunabe/lgo/cmd/lgo \
#    && go get -d github.com/yunabe/lgo/cmd/lgo-internal

# Install packages used from example notebooks.
#RUN go get -u github.com/nfnt/resize gonum.org/v1/gonum/... gonum.org/v1/plot/... github.com/wcharczuk/go-chart

# Install lgo
#RUN lgo install \
#    && lgo installpkg github.com/nfnt/resize gonum.org/v1/gonum/... gonum.org/v1/plot/... github.com/wcharczuk/go-chart
#RUN python3 $GOPATH/src/github.com/yunabe/lgo/bin/install_kernel

RUN GOPATH=/go go get github.com/gopherdata/gophernotes \
    && cd /go/src/github.com/gopherdata/gophernotes \
    && GOPATH=/go GO111MODULE=on go install .

RUN cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* $GOPHERNOTESPATH\
    && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < ${GOPHERNOTESPATH}kernel.json.in > ${GOPHERNOTESPATH}kernel.json \
    && cat ${GOPHERNOTESPATH}kernel.json

WORKDIR /workspace

VOLUME [ "/workspace" ]

EXPOSE 8888

# Notes:
# 1. Do not use ENTRYPOINT because mybinder need to run a custom command.
# 2. To use JupyterLab, replace "notebook" with "lab".
# 3. Set --allow-root in case you want to run jupyter as root.
CMD ["jupyter", "lab", "--ip=0.0.0.0"]

