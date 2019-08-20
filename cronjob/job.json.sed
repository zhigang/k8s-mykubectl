{
    "apiVersion": "batch/v1",
    "kind": "Job",
    "metadata": {
        "name": "$JOB_NAME",
        "namespace": "$NAMESPACE",
        "labels": {
            "job": "$JOB_NAME"
        }
    },
    "spec": {
        "backoffLimit": 5,
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
                "restartPolicy": "Never"
           }
        }
    }
}