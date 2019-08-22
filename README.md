# Kubectl for quick deploy

## Docker image

Docker image already pushed to docker hub, image name: "siriuszg/k8s-kubectl:TAG".

```bash
docker pull siriuszg/k8s-kubectl:TAG
```

## Docker tag

* v1.14.6
* v1.14.6-job
* v1.14.4
* v1.14.4-job
* v1.10.13-readiness
* v1.10.13
* v1.10.13-job
* v1.8.15
* v1.8.15-job
* v1.8.15-hw
* v1.8.10
* v1.8.10-hw
* v1.8.10-job

## Use service type

* KUBE_SERVICE_TYPE:
  * ClusterIP
  * NodePort, It need setting nodeport like '{ "port": 5000, "nodePort": 30001}'

## Use environment

```bash
export KUBE_ENVIRONMENT="{\"name\": \"ASPNETCORE_ENVIRONMENT\",\"value\": \"staging\"}, \
{\"name\": \"TEST_ENVIRONMENT\",\"value\": \"test\"}"

OR

export KUBE_ENVIRONMENT='{"name": "ASPNETCORE_ENVIRONMENT","value": "staging"},{"name": "TEST_ENVIRONMENT","value": "test"}'

```

## How to deploy application

```bash

export DOCKER_APP_NAME='order-grab-service'
export PUSH_TAG='prd'
export KUBE_APP=$DOCKER_APP_NAME
export KUBE_NAMESPACE='order-cloud'
export KUBE_REPLICAS=2
export KUBE_RESOURCES='{"limits": {"cpu": "1000m","memory": "512Mi" }, "requests": {"cpu": "50m","memory": "64Mi" }}'
export KUBE_ENVIRONMENT='{"name": "CONFIGOR_ENV","value": "production"}'
export KUBE_PORTS='{"containerPort": 5000}'
export KUBE_SERVICE_TYPE='NodePort'
export KUBE_SERVICE_PORTS='{ "port": 5000, "nodePort": 30001}'
export KUBE_SERVICE_ANNOTATIONS='{"nginx.gateway.type": "api"}'
export KUBE_INGRESS_RULES='{                                                                                                        \
        "host": "test.mydomain.com",                                                                                                           \
        "http": { "paths": [ { "path": "/order-grab", "backend": { "serviceName": "${KUBE_APP}", "servicePort": 30001 } } ] }       \
        }'
export KUBE_INGRESS_ANNOTATIONS="kong"
export KUBE_INGRESS_TLS_SECRET='{"secretName":"mydomain-ssl","hosts":["test.mydomain.com"]}'

export KUBE_IMAGE_PULL_SECRETS='{"name":"default-secret"}'
export KUBE_IMAGE="nginx:1.15-alpine"

docker run --rm -t -e KUBECONFIG="/usr/local/kube/deploy.conf" \
-v /host/path/kubeconfig:/usr/local/kube/deploy.conf \
siriuszg/k8s-kubectl:TAG "${KUBE_APP}" "${KUBE_NAMESPACE}" \
"${KUBE_REPLICAS}" "${KUBE_IMAGE}" \
"${KUBE_RESOURCES}" "${KUBE_ENVIRONMENT}" \
"${KUBE_PORTS}" "${KUBE_SERVICE_TYPE}" \
"${KUBE_SERVICE_PORTS}" "${KUBE_SERVICE_ANNOTATIONS}" \
"${KUBE_INGRESS_RULES}" "${KUBE_INGRESS_ANNOTATIONS}" \
"${KUBE_INGRESS_TLS_SECRET}" "${KUBE_IMAGE_PULL_SECRETS}"
```

## How to deploy cron job

```bash
export JOB_NAME='test-job'
export JOB_NAMESPACE='test'
export JOB_SCHEDULE='01 *\/1 * * *' # create a cornjob
# export JOB_SCHEDULE='job' # create a job
export JOB_POLICY='Forbid'
export JOB_IMAGE='busybox'
export JOB_RESOURCES='{"limits": {"cpu": "150m","memory": "256Mi" }, "requests": {"cpu": "50m","memory": "128Mi" }}'
export JOB_ENVIRONMENT='{"name": "ASPNETCORE_ENVIRONMENT","value": "staging"},{"name": "TEST_ENVIRONMENT","value": "test,has,production,test,qas"}'
export JOB_ARGS='["echo","hello,world!"]'
export JOB_IMAGE_PULL_SECRETS='{"name":"default-secret"}'

docker run --rm -t -e KUBECONFIG="/usr/local/kube/deploy.conf" \
-v /host/path/kubeconfig:/usr/local/kube/deploy.conf \
siriuszg/k8s-kubectl:TAG "${JOB_NAME}" "${JOB_NAMESPACE}" \
"${JOB_SCHEDULE}" "${JOB_POLICY}" \
"${JOB_IMAGE}" "${JOB_RESOURCES}" \
"${JOB_ENVIRONMENT}" "${JOB_ARGS}" \
"${JOB_IMAGE_PULL_SECRETS}"
```
