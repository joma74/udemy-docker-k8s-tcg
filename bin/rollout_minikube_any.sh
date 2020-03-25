#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROOT=$DIR/../

set -x

kubectl rollout restart deployment

set +x

set +e