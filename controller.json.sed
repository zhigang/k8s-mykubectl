{
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "$APP_NAME",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "$APP_NAME"
    },
    "annotations": {
      "kubernetes.io/change-cause": "docker images is $IMAGE"
    }
  },
  "spec": {
    "replicas": $REPLICAS,
    "revisionHistoryLimit": 5,
    "selector": {
      "matchLabels": {
        "app": "$APP_NAME"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "app": "$APP_NAME"
        }
      },
      "spec": {
        "imagePullSecrets": [$IMAGE_PULL_SECRETS],
        "nodeSelector": { "app-ready": "true" },
        "terminationGracePeriodSeconds": 60,
        "containers": [
          {
            "name": "$APP_NAME",
            "image": "$IMAGE",
            "resources": $RESOURCES,
            "env": [$ENVIRONMENT],
            "ports": $PORTS,
            "readinessProbe": $READINESSPROBE,
            "livenessProbe": $LIVENESSPROBE,
            "imagePullPolicy": "Always"
          }
        ]
      }
    }
  }
}
