{
    "apiVersion": "extensions/v1beta1",
    "kind": "Ingress",
    "metadata": {
        "name": "$APP_NAME",
        "namespace": "$NAMESPACE",
        "labels": {
            "app": "$APP_NAME",
            "zone": "data",
            "isExternal": "true"
        },
        "annotations": $ANNOTATIONS
    },
    "spec": {
        "rules": [$INGRESS_RULES],
        "tls": [$INGRESS_TLS_SECRET]
    }
}