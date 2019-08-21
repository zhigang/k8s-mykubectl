{
    "apiVersion": "extensions/v1beta1",
    "kind": "Ingress",
    "metadata": {
        "name": "$APP_NAME",
        "namespace": "$NAMESPACE",
        "annotations": $ANNOTATIONS,
        "labels": {
            "app": "$APP_NAME"
        }
    },
    "spec": {
        "tls": [$INGRESS_TLS_SECRET],
        "rules": [$INGRESS_RULES]
    }
}