#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PROOT=$DIR/../

set -x

docker build -t ${IMAGE_NAME_PROXY_PROD} -t ${IMAGE_NAME_PROXY_DEV} -f $PROOT/fibonacci-calc-proxy/Dockerfile $PROOT/fibonacci-calc-proxy

set +x