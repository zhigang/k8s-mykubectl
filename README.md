# Kubectl for quick deploy

## Docker image

Docker image already pushed to docker hub, image name: "siriuszg/k8s-kubectl:TAG".

```bash
docker pull siriuszg/k8s-kubectl:TAG
```

## Docker tag

* v1.8.15
* v1.8.10
* v1.8.10-hw
* v1.8.10-job

## How to use

Deploy to nginx lb use annotations:

* nginx.gateway.type
  * value is api, website, wxqy-website.
* nginx.gateway.domain:
  * if nginx.gateway.type is website or wxqy-website have to set this annotation.
* nginx.gateway.url:
  * if nginx.gateway.type is api need this annotation, this can be none.
* KUBE_SERVICE_TYPE:
  * ClusterIP
  * NodePort, It need setting nodeport like '{ "port": 5000, "nodePort": 30001}'

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
#export KUBE_SERVICE_ANNOTATIONS='{"nginx.gateway.type": "api","nginx.gateway.url":"test"}'
#export KUBE_SERVICE_ANNOTATIONS='{"nginx.gateway.type": "website","nginx.gateway.domain":"mydomain"}'
#export KUBE_SERVICE_ANNOTATIONS='{"nginx.gateway.type": "wxqy-website","nginx.gateway.domain":"mydomain"}'
export KUBE_INGRESS_RULES='{                                                                                                        \
        "host": "domain",                                                                                                           \
        "http": { "paths": [ { "path": "/order-grab", "backend": { "serviceName": "${KUBE_APP}", "servicePort": 30001 } } ] }       \
        }'
export KUBE_INGRESS_ANNOTATIONS="kong"
export KUBE_INGRESS_TLS_SECRET=""

docker run --rm -t -e KUBECONFIG="/usr/local/kube/deploy.conf" \
-v /host/path/kubeconfig:/usr/local/kube/deploy.conf \
siriuszg/k8s-kubectl:TAG "${KUBE_APP}" "${KUBE_NAMESPACE}" \
"${KUBE_REPLICAS}" "${KUBE_IMAGE}" \
"${KUBE_RESOURCES}" "${KUBE_ENVIRONMENT}" \
"${KUBE_PORTS}" "${KUBE_SERVICE_TYPE}" \
"${KUBE_SERVICE_PORTS}" "${KUBE_SERVICE_ANNOTATIONS}" \
"${KUBE_INGRESS_RULES}" "${KUBE_INGRESS_ANNOTATIONS}" \
"${KUBE_INGRESS_TLS_SECRET}"
```

## Use Environment

```bash
export KUBE_ENVIRONMENT="{\"name\": \"ASPNETCORE_ENVIRONMENT\",\"value\": \"staging\"}, \
{\"name\": \"TEST_ENVIRONMENT\",\"value\": \"test\"}"

OR

export KUBE_ENVIRONMENT='{"name": "ASPNETCORE_ENVIRONMENT","value": "staging"},{"name": "TEST_ENVIRONMENT","value": "test"}'

```

## How to deploy cron job

```bash
export JOB_NAME='test-job'
export JOB_NAMESPACE='test'
export JOB_SCHEDULE='01 *\/1 * * *'
export JOB_POLICY='Forbid'
export JOB_IMAGE='busybox'
export JOB_RESOURCES='{"limits": {"cpu": "150m","memory": "256Mi" }, "requests": {"cpu": "50m","memory": "128Mi" }}'
export JOB_ENVIRONMENT='{"name": "ASPNETCORE_ENVIRONMENT","value": "staging"},{"name": "TEST_ENVIRONMENT","value": "test,has,production,test,qas"}'
export JOB_ARGS='["echo","hello,world!"]'
export KUBE_API="https://127.0.0.1"

docker run --rm -t -e KUBECONFIG="/usr/local/kube/deploy.conf" \
-v /host/path/kubeconfig:/usr/local/kube/deploy.conf \
siriuszg/k8s-kubectl:TAG "${JOB_NAME}" "${JOB_NAMESPACE}" \
"${JOB_SCHEDULE}" "${JOB_POLICY}" \
"${JOB_IMAGE}" "${JOB_RESOURCES}" \
"${JOB_ENVIRONMENT}" "${JOB_ARGS}" \
"${KUBE_API}"
```

## Build Docker Iamge

```bash
docker build --force-rm=true -t siriuszg/k8s-kubectl:TAG .
```