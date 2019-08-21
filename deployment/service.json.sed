{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "$APP_NAME",
    "namespace": "$NAMESPACE",
    "annotations": $ANNOTATIONS,
    "labels": {
      "app": "$APP_NAME"
    }
  },
  "spec": {
    "type": "$SERVICE_TYPE",
    "selector": {
      "app": "$APP_NAME"
    },
    "ports": [$SERVICE_PORTS]
  }
}
