#!/usr/bin/env bash

docker push "${IMAGE_NAME_FRONTEND_PROD}"
docker push "${IMAGE_NAME_SERVER_PROD}"
docker push "${IMAGE_NAME_WORKER_PROD}"