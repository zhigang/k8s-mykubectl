{
    "apiVersion": "batch/v2alpha1",
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
                        "containers": [
                            {
                                "name": "$JOB_NAME",
                                "image": "$IMAGE",
                                "imagePullPolicy": "Always",
                                "resources": $RESOURCES,
                                "env": [$ENVIRONMENT],
                                "args": $ARGS
                            }
                        ],
                        "restartPolicy": "OnFailure"
                    }
                }
            }
        }
    }
}