#!/usr/bin/env bash

kubectl apply -f k8s

kubectl set image deployment/frontend-deployment frontend=${IMAGE_NAME_FRONTEND_PROD}
kubectl set image deployment/server-deployment server=${IMAGE_NAME_SERVER_PROD}
kubectl set image deployment/worker-deployment worker=${IMAGE_NAME_WORKER_PROD}