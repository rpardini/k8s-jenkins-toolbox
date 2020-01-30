FROM alpine

ENV KUBE_LATEST_VERSION="v1.17.2"
ENV HELM_LATEST_VERSION="v3.0.3"
ENV KUBERNETES_DEPLOY_LATEST_VERSION="0.31.1"

RUN set -x && apk add --update ca-certificates jq curl bash git py2-pip python2 build-base ruby ruby-dev ruby-json ruby-bigdecimal \
 && apk add --update -t deps curl \
 && pip install yq \
 && gem install --no-document  kubernetes-deploy -v ${KUBERNETES_DEPLOY_LATEST_VERSION} \
 && apk del --purge py2-pip build-base ruby-dev\
 && apk del --purge deps \

#RUN set -x \
 && mkdir -p /tmp/kube && cd /tmp/kube && curl -L https://dl.k8s.io/v1.17.2/kubernetes-client-linux-amd64.tar.gz -o - | tar xzvf - \
 && mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
 && cd /tmp && rm -rf /tmp/kube \

#RUN set -x \
 && wget https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -rf /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz linux-amd64 \

#RUN set -x \
 && rm -rf /root/.cache /root/.gem \
 && rm /var/cache/apk/*

# RUN helm --help
# RUN kubectl --help
# RUN kubernetes-deploy --help

SHELL ["/bin/bash"]

WORKDIR /root
CMD ["bash"]
