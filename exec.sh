#!/bin/bash
set -o errexit

if [[ "$1" == "help" ]]; then
  cat exechelp
  exit 0;
fi

if [ $# != 12 ] ; then
  echo "lost some argments.ex:"
  cat exechelp
  exit 1;
fi

KUBE_APP=$1
KUBE_NAMESPACE=$2
KUBE_REPLICAS=$3
KUBE_IMAGE=$4
KUBE_RESOURCES=$5
KUBE_ENVIRONMENT=$6
KUBE_PORTS=$7
KUBE_SERVICE_TYPE=$8
KUBE_SERVICE_PORTS=$9
KUBE_USE_INGRESS=$10
KUBE_SVC_ANNOTATIONS=$11
INGRESS_RULES=$12
INGRESS_TLS_SECRET=$13

#function

create_controller_config()
{
  KUBE_ENVIRONMENT=`echo $KUBE_ENVIRONMENT | sed 's#\/#\\\/#g'`
  KUBE_IMAGE_SED=`echo $KUBE_IMAGE | sed 's#\/#\\\/#g'`
  
  sed -e "s/\\\$APP_NAME/${KUBE_APP}/g;s/\\\$NAMESPACE/${KUBE_NAMESPACE}/g;s/\\\$REPLICAS/${KUBE_REPLICAS}/g;s/\\\$IMAGE/${KUBE_IMAGE_SED}/g;s/\\\$RESOURCES/${KUBE_RESOURCES}/g;s/\\\$ENVIRONMENT/${KUBE_ENVIRONMENT}/g;s/\\\$PORTS/${KUBE_PORTS}/g;" \
  "controller.json.sed" > controller.json
  
  echo
  cat controller.json
  echo
}

create_service_config()
{
  sed -e "s/\\\$APP_NAME/${KUBE_APP}/g;s/\\\$NAMESPACE/${KUBE_NAMESPACE}/g;s/\\\$SERVICE_TYPE/${KUBE_SERVICE_TYPE}/g;s/\\\$SERVICE_PORTS/${KUBE_SERVICE_PORTS}/g;s/\\\$ANNOTATIONS/${KUBE_SVC_ANNOTATIONS}/g;" \
  "./service.json.sed" > ./service.json

  echo
  cat service.json
  echo
}

create_ingress_config()
{
  sed -e "s/\\\$APP_NAME/${KUBE_APP}/g;s/\\\$NAMESPACE/${KUBE_NAMESPACE}/g;s/\\\$INGRESS_RULES/${INGRESS_RULES}/g;s/\\\$INGRESS_TLS_SECRET/${INGRESS_TLS_SECRET}/g;" \
  "./ingress.json.sed" > ./ingress.json

  echo
  cat ingress.json
  echo
}

# deploy

create_controller_config

if [ -f controller.json ]; then
  echo "Deployment ${KUBE_NAMESPACE}.${KUBE_APP}, Apply a configuration to a resource."
  kubectl apply -f ./controller.json
else
  echo "Lost controller.json."
fi

if [ "${KUBE_SERVICE_TYPE}" = "" ]; then
  echo "Don't need deployment service ${KUBE_NAMESPACE}.${KUBE_APP} ."
  exit 0;
fi

create_service_config

if [ -f ./service.json ]; then
  echo "Service ${KUBE_NAMESPACE}.${KUBE_APP}, Apply a configuration to a resource."
  kubectl apply -f ./service.json
else
    echo "Lost service.json."
fi

if [ "${KUBE_USE_INGRESS}" = "true" ]; then
  create_ingress_config

  if [ -f ./ingress.json ]; then
    echo "Ingress ${KUBE_NAMESPACE}.${KUBE_APP}, Apply a configuration to a resource."
    kubectl apply -f ./ingress.json
  else
      echo "Lost ingress.json."
  fi
else
  echo "Don't need deployment ingress ${KUBE_NAMESPACE}.${KUBE_APP} ."
  exit 0;
fi

exit 0;

