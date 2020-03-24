#!/usr/bin/env bash

set -x

docker image pull redis:latest
docker image tag redis:latest ${IMAGE_NAME_REDIS_PROD}
docker image tag redis:latest ${IMAGE_NAME_REDIS_GCP_PROD}
docker image pull postgres:latest
docker image tag postgres:latest ${IMAGE_NAME_POSTGRES_PROD}
docker image tag postgres:latest ${IMAGE_NAME_POSTGRES_GCP_PROD}
docker build -t ${IMAGE_NAME_FRONTEND_PROD} -t ${IMAGE_NAME_FRONTEND_GCP_PROD} -t ${IMAGE_NAME_FRONTEND_GCP_PROD}:$GIT_SHA -f ./fibonacci-calc-frontend/Dockerfile ./fibonacci-calc-frontend
docker build -t ${IMAGE_NAME_SERVER_PROD} -t ${IMAGE_NAME_SERVER_GCP_PROD} -t ${IMAGE_NAME_SERVER_GCP_PROD}:$GIT_SHA -f ./fibonacci-calc-server/Dockerfile ./fibonacci-calc-server
docker build -t ${IMAGE_NAME_WORKER_PROD} -t ${IMAGE_NAME_WORKER_GCP_PROD} -t ${IMAGE_NAME_WORKER_GCP_PROD}:$GIT_SHA -f ./fibonacci-calc-worker/Dockerfile ./fibonacci-calc-worker

set +x