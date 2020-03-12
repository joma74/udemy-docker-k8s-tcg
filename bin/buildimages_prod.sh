#!/usr/bin/env bash

set -x

docker build -t ${IMAGE_NAME_FRONTEND_PROD} -t ${IMAGE_NAME_FRONTEND_PROD}:$GIT_SHA -f ./fibonacci-calc-frontend/Dockerfile ./fibonacci-calc-frontend
docker build -t ${IMAGE_NAME_SERVER_PROD} -t ${IMAGE_NAME_SERVER_PROD}:$GIT_SHA -f ./fibonacci-calc-server/Dockerfile ./fibonacci-calc-server
docker build -t ${IMAGE_NAME_WORKER_PROD} -t ${IMAGE_NAME_WORKER_PROD}:$GIT_SHA -f ./fibonacci-calc-worker/Dockerfile ./fibonacci-calc-worker

set +x