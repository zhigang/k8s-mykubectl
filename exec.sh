#!/bin/bash
set -o errexit

if [[ "$1" == "help" ]]; then
  cat exechelp
  exit 0;
fi

NAME=$1
NAMESPACE=$2
REPLICAS=$3
IMAGE=$4
RESOURCES=$5
ENVIRONMENTS=$6
PORTS=$7
SERVICE_TYPE=$8
SERVICE_PORTS=$9
SERVICE_ANNOTATIONS=$10
INGRESS_RULES=$11
INGRESS_ANNOTATIONS=$12
INGRESS_TLS_SECRET=$13

# function start
lost_arg_error()
{
  echo "Need some argments. ex:"
  cat exechelp
  exit 1;
}

create_controller_config()
{
  if [ -z $NAME ] && [ -z $NAMESPACE ] && [ -z $REPLICAS ] && [ -z $IMAGE ] && [ -z $RESOURCES ] && [ -z $PORTS ]; then
    echo "Cann't create deployment json."
    lost_arg_error
  fi
  
  if [ -z $PORTS ]; then
    sed -i "/ports/d" "controller.json.sed"
  fi

  ENVIRONMENTS=`echo $ENVIRONMENTS | sed 's#\/#\\\/#g'`
  IMAGE=`echo $IMAGE | sed 's#\/#\\\/#g'`
  
  sed -e "s/\\\$APP_NAME/${NAME}/g;s/\\\$NAMESPACE/${NAMESPACE}/g;s/\\\$REPLICAS/${REPLICAS}/g;s/\\\$IMAGE/${IMAGE}/g;s/\\\$RESOURCES/${RESOURCES}/g;s/\\\$ENVIRONMENT/${ENVIRONMENTS}/g;s/\\\$PORTS/${PORTS}/g;" \
  "controller.json.sed" > controller.json
  
  echo
  cat controller.json
  echo
}

create_service_config()
{
  if [ -z $NAME ] && [ -z $NAMESPACE ] && [ -z $SERVICE_TYPE ] && [ -z $SERVICE_PORTS ]; then
    echo "Cann't create service json."
    lost_arg_error
  fi

  if [ -z $SERVICE_ANNOTATIONS ]; then
    SERVICE_ANNOTATIONS="{}"
  else
    SERVICE_ANNOTATIONS=`echo $SERVICE_ANNOTATIONS | sed 's#\/#\\\/#g'`
  fi
  
  sed -e "s/\\\$APP_NAME/${NAME}/g;s/\\\$NAMESPACE/${NAMESPACE}/g;s/\\\$SERVICE_TYPE/${SERVICE_TYPE}/g;s/\\\$SERVICE_PORTS/${SERVICE_PORTS}/g;s/\\\$ANNOTATIONS/${SERVICE_ANNOTATIONS}/g;" \
  "./service.json.sed" > ./service.json

  echo
  cat service.json
  echo
}

create_ingress_config()
{
  if [ -z $NAME ] && [ -z $NAMESPACE ] && [ -z $INGRESS_RULES ]; then
    echo "Cann't create ingress json."
    lost_arg_error
  fi

  if [ -z $INGRESS_ANNOTATIONS ]; then
    INGRESS_ANNOTATIONS="{}"
  elif [ "${INGRESS_ANNOTATIONS}" = "hw" ]; then
    INGRESS_ANNOTATIONS='{ "ingress.kubernetes.io/add-base-url": "false", "ingress.kubernetes.io/rewrite-target": "/", "ingress.kubernetes.io/secure-backends": "false", "ingress.beta.kubernetes.io/role": "data" }'
  elif [ "${INGRESS_ANNOTATIONS}" = "nginx" ]; then
    INGRESS_ANNOTATIONS='{ "kubernetes.io/ingress.class": "nginx", "ingress.kubernetes.io/add-base-url": "false", "ingress.kubernetes.io/rewrite-target": "/" }'
  elif [ "${INGRESS_ANNOTATIONS}" = "kong" ]; then
    INGRESS_ANNOTATIONS='{ "kubernetes.io/ingress.class": "kong", "configuration.konghq.com": "need-strip-path" }'
  fi

  INGRESS_RULES=`echo $INGRESS_RULES | sed 's#\/#\\\/#g'`
  INGRESS_ANNOTATIONS=`echo $INGRESS_ANNOTATIONS | sed 's#\/#\\\/#g'`

  sed -e "s/\\\$APP_NAME/${NAME}/g;s/\\\$NAMESPACE/${NAMESPACE}/g;s/\\\$INGRESS_RULES/${INGRESS_RULES}/g;s/\\\$INGRESS_TLS_SECRET/${INGRESS_TLS_SECRET}/g;s/\\\$ANNOTATIONS/${INGRESS_ANNOTATIONS}/g;" \
  "./ingress.json.sed" > ./ingress.json

  echo
  cat ingress.json
  echo
}

# function end

# 1. Apply a deployment
create_controller_config

if [ -f controller.json ]; then
  echo "Deployment ${NAMESPACE}.${NAME}, Apply a configuration to a resource."
  kubectl apply -f ./controller.json
else
  echo "Lost controller.json."
fi

# 2. Apply a service
if [ "${SERVICE_TYPE}" = "" ]; then
  echo "Service type is null. Don't need deployment service ${NAMESPACE}.${NAME} ."
  exit 0;
fi

create_service_config

if [ -f ./service.json ]; then
  echo "Service ${NAMESPACE}.${NAME}, Apply a configuration to a resource."
  kubectl apply -f ./service.json
else
    echo "Lost service.json."
fi

# 3. Apply a ingress
if [ "${INGRESS_RULES}" = "" ]; then
  echo "Ingress rules is null. Don't need deployment ingress ${NAMESPACE}.${NAME} ."
  exit 0;
fi

if kubectl get ing $NAME -n $NAMESPACE &> /dev/null; then
  echo "Ingress ${NAMESPACE}.${NAME} already exists. Don't need deployment."
else
  create_ingress_config
  
  if [ -f ./ingress.json ]; then
    echo "Ingress ${NAMESPACE}.${NAME}, Apply a configuration to a resource."
    kubectl apply -f ./ingress.json
  else
      echo "Lost ingress.json."
  fi
fi

exit 0;
