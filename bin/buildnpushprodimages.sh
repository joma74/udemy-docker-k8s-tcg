#!/usr/bin/env bash

docker build -t ${IMAGE_NAME_FRONTEND_PROD} -f ./fibonacci-calc-frontend/Dockerfile ./fibonacci-calc-frontend
docker build -t ${IMAGE_NAME_SERVER_PROD} -f ./fibonacci-calc-server/Dockerfile ./fibonacci-calc-server
docker build -t ${IMAGE_NAME_WORKER_PROD} -f ./fibonacci-calc-worker/Dockerfile ./fibonacci-calc-worker

docker push "${IMAGE_NAME_FRONTEND_PROD}"
docker push "${IMAGE_NAME_SERVER_PROD}"
docker push "${IMAGE_NAME_WORKER_PROD}"