{
  "apiVersion": "extensions/v1beta1",
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
        "containers": [
          {
            "name": "$APP_NAME",
            "image": "$IMAGE",
            "resources": $RESOURCES,
            "env": [$ENVIRONMENT],
            "ports": [$PORTS]
          }
        ]
      }
    }
  }
}
