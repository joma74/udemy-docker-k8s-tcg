#!/usr/bin/env bash

set -x

docker push "${${IMAGE_NAME_FRONTEND_GCP_PROD}}"
docker push "${IMAGE_NAME_SERVER_GCP_PROD}"
docker push "${IMAGE_NAME_WORKER_GCP_PROD}"

set +x