FROM alpine

ENV KUBE_LATEST_VERSION="v1.10.5"
ENV HELM_LATEST_VERSION="v2.9.1"
ENV KUBERNETES_DEPLOY_LATEST_VERSION="0.20.3"

RUN apk add --update ca-certificates jq curl bash git py2-pip python2 build-base ruby ruby-dev ruby-json \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -rf /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz linux-amd64 \ 
 && pip install yq \
 && gem install --no-document  kubernetes-deploy -v ${KUBERNETES_DEPLOY_LATEST_VERSION} \
 && apk del --purge py2-pip build-base ruby-dev\
 && apk del --purge deps \
 && rm -rf /root/.cache /root/.gem \
 && rm /var/cache/apk/*

# RUN helm --help
# RUN kubectl --help
# RUN kubernetes-deploy --help

SHELL ["/bin/bash"]

WORKDIR /root
CMD ["bash"]
