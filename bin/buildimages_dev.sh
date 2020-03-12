#!/usr/bin/env bash

set -x

docker build -t ${IMAGE_NAME_FRONTEND_DEV} -f ./fibonacci-calc-frontend/Dockerfile.dev ./fibonacci-calc-frontend
docker build -t ${IMAGE_NAME_SERVER_DEV} -f ./fibonacci-calc-server/Dockerfile.dev ./fibonacci-calc-server
docker build -t ${IMAGE_NAME_WORKER_DEV} -f ./fibonacci-calc-worker/Dockerfile.dev ./fibonacci-calc-worker

set +x