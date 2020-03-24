#!/usr/bin/env bash

set -x

docker image pull redis:latest
docker image tag redis:latest ${IMAGE_NAME_REDIS_DEV}
docker image pull postgres:latest
docker image tag postgres:latest ${IMAGE_NAME_POSTGRES_DEV}
docker build -t ${IMAGE_NAME_FRONTEND_DEV} -f ./fibonacci-calc-frontend/Dockerfile.dev ./fibonacci-calc-frontend
docker build -t ${IMAGE_NAME_API_DEV} ${IMAGE_NAME_SERVER_DEV} -f ./fibonacci-calc-server/Dockerfile.dev ./fibonacci-calc-server
docker build -t ${IMAGE_NAME_WORKER_DEV} -f ./fibonacci-calc-worker/Dockerfile.dev ./fibonacci-calc-worker

set +x