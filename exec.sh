#!/bin/bash
set -o errexit

if [[ "$1" == "help" ]]; then
  cat exechelp
  exit 0;
fi

if [ $# != 11 ] ; then
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
KUBE_API=$10
KUBE_SVC_ANNOTATIONS=$11

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

# deploy

# if ! kubectl get namespace | grep "${KUBE_NAMESPACE}" &> /dev/null; then
#   echo "Create namespace ${KUBE_NAMESPACE}."
#   kubectl create namespace $KUBE_NAMESPACE
# fi

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

sed -e "s/\\\$APP_NAME/${KUBE_APP}/g;s/\\\$NAMESPACE/${KUBE_NAMESPACE}/g;s/\\\$SERVICE_TYPE/${KUBE_SERVICE_TYPE}/g;s/\\\$SERVICE_PORTS/${KUBE_SERVICE_PORTS}/g;s/\\\$ANNOTATIONS/${KUBE_SVC_ANNOTATIONS}/g;" \
  "./service.json.sed" > ./service.json

echo
cat service.json
echo

if [ -f ./service.json ]; then
  echo "Service ${KUBE_NAMESPACE}.${KUBE_APP}, Apply a configuration to a resource."
  kubectl apply -f ./service.json
else
    echo "Lost service.json."
fi

exit 0;

