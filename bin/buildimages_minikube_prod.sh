#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROOT=$DIR/../

. $DIR/exporttravisenvglobaltolocalenv.sh

set -x

eval $(minikube docker-env)

set +x

$DIR/buildimages_any_prod.sh

set +e