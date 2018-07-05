FROM alpine

ENV KUBE_LATEST_VERSION="v1.10.5"

RUN apk add --update ca-certificates jq curl bash git py2-pip python2 \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && pip install yq \
 && apk del --purge deps \
 && apk del --purge py2-pip \
 && rm /var/cache/apk/*

WORKDIR /root
CMD ["kubectl"]
