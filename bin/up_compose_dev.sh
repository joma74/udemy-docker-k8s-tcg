#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROOT=$DIR/../

. $DIR/exporttravisenvglobaltolocalenv.sh

$DIR/buildimages_compose_any.sh

$DIR/buildimages_any_dev.sh

docker-compose -f docker-compose-dev.yml up --renew-anon-volumes

set +e