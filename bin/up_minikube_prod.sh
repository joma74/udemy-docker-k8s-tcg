#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROOT=$DIR/../

. $DIR/exporttravisenvglobaltolocalenv.sh

$DIR/buildimages_minikube_prod.sh

$DIR/execkubectlcommands.sh

$DIR/rollout_minikube_any.sh

set +e