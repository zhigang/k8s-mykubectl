FROM lachlanevenson/k8s-kubectl:v1.18.15

LABEL maintainer="siriuszg <zhigang52110@sina.com>"

WORKDIR /usr/local/kube

COPY ./cronjob    .

ENTRYPOINT ["/bin/sh","/usr/local/kube/exec.sh"]

CMD ["help"]
