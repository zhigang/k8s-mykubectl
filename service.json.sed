{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "$APP_NAME",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "$APP_NAME"
    },
    "annotations": $ANNOTATIONS
  },
  "spec": {
    "type": "$SERVICE_TYPE",
    "selector": {
      "app": "$APP_NAME"
    },
    "ports": [$SERVICE_PORTS]
  }
}
