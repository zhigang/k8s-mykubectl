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
        "annotations": {
            "ingress.kubernetes.io/add-base-url": "false",
            "ingress.kubernetes.io/rewrite-target": "/",
            "ingress.kubernetes.io/secure-backends": "false",
            "ingress.beta.kubernetes.io/role": "data"
        }
    },
    "spec": {
        "rules": [$INGRESS_RULES],
        "tls": [$INGRESS_TLS_SECRET]
    }
}