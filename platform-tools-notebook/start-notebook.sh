#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e
export CGO_ENABLED=0
export GO111MODULE=on

wrapper=""
if [[ "${RESTARTABLE}" == "yes" ]]; then
  wrapper="run-one-constantly"
fi

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # launched by JupyterHub, use single-user entrypoint
  exec /usr/local/bin/start-singleuser.sh "$@"
elif [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
  exec jupyter lab "$@"
elif [[ ! -z "${JUPYTER_ENABLE}" ]]; then
  exec jupyter notebook "$@"
else
  exec /bin/bash
fi