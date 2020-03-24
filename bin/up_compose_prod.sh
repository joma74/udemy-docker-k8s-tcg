#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROOT=$DIR/../

. $DIR/exporttravisenvglobaltolocalenv.sh

$DIR/buildimages_compose_any.sh

$DIR/buildimages_any_prod.sh

docker-compose up --renew-anon-volumes

set +e