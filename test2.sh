#!/bin/bash
set -e

export JOB_NAME='test-job'
export JOB_NAMESPACE='test'
export JOB_SCHEDULE='01 *\/1 * * *'
export JOB_POLICY='Forbid'
export JOB_IMAGE='busybox'
export JOB_RESOURCES='{"limits": {"cpu": "150m","memory": "256Mi" }, "requests": {"cpu": "50m","memory": "128Mi" }}'
export JOB_ENVIRONMENT='{"name":"ASPNETCORE_ENVIRONMENT","value":"staging"},{"name":"TEST_ENVIRONMENT","value":"test,has,production,test,qas"}'
export JOB_ARGS='["echo","hello,world!"]'
export JOB_IMAGE_PULL_SECRETS='{"name":"default-secret"}'

docker run --rm -t siriuszg/k8s-kubectl:v1.10.13-job "${JOB_NAME}" "${JOB_NAMESPACE}" \
"${JOB_SCHEDULE}" "${JOB_POLICY}" \
"${JOB_IMAGE}" "${JOB_RESOURCES}" \
"${JOB_ENVIRONMENT}" "${JOB_ARGS}" \
"${JOB_IMAGE_PULL_SECRETS}"
