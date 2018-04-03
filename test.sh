#!/bin/bash
set -e

## export KUBE_ENVIRONMENT="{\"name\": \"ASPNETCORE_ENVIRONMENT\",\"value\": \"staging\"}, \
## {\"name\": \"ASPNETCORE_ENVIRONMENT\",\"value\": \"staging\"}"
export DOCKER_APP_NAME='nginx-example'
export KUBE_APP=$DOCKER_APP_NAME
export KUBE_NAMESPACE='test'
export KUBE_REPLICAS=2
export KUBE_RESOURCES='{"limits": {"cpu": "150m","memory": "128Mi" }, "requests": {"cpu": "150m","memory": "128Mi" }}'
export KUBE_ENVIRONMENT='{"name": "ASPNETCORE_ENVIRONMENT","value": "staging"},{"name": "TEST_ENVIRONMENT","value": "test,has,production,test,qas"},{"name": "ENDPOINT","value": "http://0.0.0.0"}'
export KUBE_PORTS='{"containerPort": 80}'
export KUBE_SERVICE_TYPE='NodePort'
export KUBE_SERVICE_PORTS='{ "port": 80, "nodePort": 30080}'
export KUBE_API="127.0.0.1:8080"
#1.11.6-alpine 1.10.2-alpine
export KUBE_IMAGE="nginx:1.11.6-alpine"

docker run --rm -t siriuszg/k8s-kubectl:v1.4.1 "${KUBE_APP}" "${KUBE_NAMESPACE}" \
"${KUBE_REPLICAS}" "${KUBE_IMAGE}" \
"${KUBE_RESOURCES}" "${KUBE_ENVIRONMENT}" \
"${KUBE_PORTS}" "${KUBE_SERVICE_TYPE}" \
"${KUBE_SERVICE_PORTS}" "${KUBE_API}"
