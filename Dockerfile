FROM lachlanevenson/k8s-kubectl:v1.14.10

LABEL maintainer="siriuszg <zhigang52110@sina.com>"

RUN apk update --no-cache && apk add --no-cache jq

WORKDIR /usr/local/kube

COPY ./deployment .

ENTRYPOINT ["/bin/sh","/usr/local/kube/exec.sh"]

CMD ["help"]
