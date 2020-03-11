#!/usr/bin/env bash

set -x

docker push "${IMAGE_NAME_FRONTEND_PROD}"
docker push "${IMAGE_NAME_SERVER_PROD}"
docker push "${IMAGE_NAME_WORKER_PROD}"

set +x