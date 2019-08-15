{
    "apiVersion": "batch/v1beta1",
    "kind": "CronJob",
    "metadata": {
        "name": "$JOB_NAME",
        "namespace": "$NAMESPACE",
        "labels": {
            "cron-job": "$JOB_NAME"
        }
    },
    "spec": {
        "schedule": "$SCHEDULE",
        "concurrencyPolicy": "$POLICY",
        "successfulJobsHistoryLimit": 5,
        "failedJobsHistoryLimit": 5,
        "jobTemplate": {
            "spec": {
                "template": {
                    "spec": {
                        "imagePullSecrets": [$IMAGE_PULL_SECRETS],
                        "containers": [
                            {
                                "name": "$JOB_NAME",
                                "image": "$IMAGE",
                                "resources": $RESOURCES,
                                "env": [$ENVIRONMENT],
                                "args": $ARGS,
                                "imagePullPolicy": "Always"
                            }
                        ],
                        "restartPolicy": "OnFailure"
                    }
                }
            }
        }
    }
}