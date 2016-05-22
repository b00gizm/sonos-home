#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PROJECT_NAME="sonos-home"
DOCKER_PREFIX="b00gizm/${PROJECT_NAME}"
K8S_NAMESPACE=$PROJECT_NAME

EXTERNAL_IP=${EXTERNAL_IP:-$(hostname -I | awk '{ print $1 }')}
MAX_DURATION=${MAX_DURATION:-60}

source ${DIR}/../shell/helpers.sh

# build base images
echo "[INFO] Building base / support images"
docker build -t "${DOCKER_PREFIX}/sonos-http-api" ${DIR}/../docker/sonos-http-api
docker build -t "${DOCKER_PREFIX}/nginx" ${DIR}/../docker/nginx

# clean start
echo "[INFO] Reloading namespace ${K8S_NAMESPACE}"
kubernetes-delete-namespace $K8S_NAMESPACE
kubernetes-create-namespace $K8S_NAMESPACE

# "compile" kubernetes config template
eval "echo \"$(cat ${DIR}/../kubernetes/app.yml.tpl)\" > ${DIR}/../kubernetes/app.yml"

# create pods, services and endpoints
kubectl create -f ${DIR}/../kubernetes/app.yml --namespace=${K8S_NAMESPACE}

# wait for environment
kubernetes-wait ${K8S_NAMESPACE} ${MAX_DURATION}

# ready to go
kubernetes-info ${K8S_NAMESPACE} ${EXTERNAL_IP}
