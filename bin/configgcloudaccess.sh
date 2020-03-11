  #!/usr/bin/env bash
  
set -x

gcloud auth activate-service-account --key-file=travisci-deployer_udemy-docker-k8s-tcg-2_key.json # login, for service accounts
gcloud auth configure-docker # login to gcr, to enable "docker push"
gcloud config set project "${GCP_PROJECT_ID}"
gcloud config set compute/zone "${CLUSTER_REGION}"
gcloud container clusters get-credentials "${CLUSTER_NAME}"

set +x