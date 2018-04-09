#!/bin/bash
set -o errexit

if [[ "$1" == "help" ]]; then
  cat exechelp
  exit 0;
fi

if [ $# != 9 ] ; then
  echo "lost some argments.ex:"
  cat exechelp
  exit 1;
fi

JOB_NAME=$1
JOB_NAMESPACE=$2
JOB_SCHEDULE=$3
JOB_POLICY=$4
JOB_IMAGE=$5
JOB_RESOURCES=$6
JOB_ENVIRONMENT=$7
JOB_ARGS=$8
KUBE_API=$9

#function

create_cronjob_config()
{
  JOB_ENVIRONMENT=`echo $JOB_ENVIRONMENT | sed 's#\/#\\\/#g'`
  JOB_IMAGE_SED=`echo $JOB_IMAGE | sed 's#\/#\\\/#g'`
  #JOB_SCHEDULE=`echo $JOB_SCHEDULE | sed 's#\/#\\\/#g'`
  JOB_ARGS=`echo $JOB_ARGS | sed 's#\/#\\\/#g'`

  sed -e "s/\\\$JOB_NAME/${JOB_NAME}/g;s/\\\$NAMESPACE/${JOB_NAMESPACE}/g;s/\\\$SCHEDULE/${JOB_SCHEDULE}/g;s/\\\$POLICY/${JOB_POLICY}/g;s/\\\$IMAGE/${JOB_IMAGE_SED}/g;s/\\\$RESOURCES/${JOB_RESOURCES}/g;s/\\\$ENVIRONMENT/${JOB_ENVIRONMENT}/g;s/\\\$ARGS/${JOB_ARGS}/g;" \
  "cronjob.json.sed" > cronjob.json
  
  echo
  cat cronjob.json
  echo
}

# deploy cron job

create_cronjob_config
echo "Cron job ${JOB_NAMESPACE}.${JOB_NAME}, Apply a configuration to a resource."
kubectl apply -f ./cronjob.json --namespace=$JOB_NAMESPACE

exit 0;

