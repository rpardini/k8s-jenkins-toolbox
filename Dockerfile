FROM alpine

ENV KUBE_LATEST_VERSION="v1.22.15"
ENV HELM_LATEST_VERSION="v3.10.0"

RUN set -x && apk add --update ca-certificates jq curl bash git net-tools coreutils python3 py3-pip groff

SHELL ["/bin/bash", "-c" ]

RUN python3 -m pip install awscli

RUN set -x \
 && { [[ "$(arch)" == "x86_86" ]] && export CURRENT_ARCH="amd64" || export CURRENT_ARCH="arm64" ; } \
 && echo "Current arch: ${CURRENT_ARCH} vs $(arch)" \
 && mkdir -p /tmp/kube && cd /tmp/kube && curl -L https://dl.k8s.io/${KUBE_LATEST_VERSION}/kubernetes-client-linux-${CURRENT_ARCH}.tar.gz -o - | tar xzvf - \
 && mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
 && cd /tmp && rm -rf /tmp/kube \

#RUN set -x \
 && wget https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-${CURRENT_ARCH}.tar.gz \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-${CURRENT_ARCH}.tar.gz \
 && mv linux-${CURRENT_ARCH}/helm /usr/local/bin \
 && rm -rf /helm-${HELM_LATEST_VERSION}-linux-${CURRENT_ARCH}.tar.gz linux-${CURRENT_ARCH} \
    
#RUN set -x \
 && rm -rf /root/.cache /root/.gem \
 && rm /var/cache/apk/*

RUN helm version
RUN kubectl version --client=true
RUN cp --version
RUN aws --version
RUN which aws
RUN which kubectl

SHELL ["/bin/bash"]

WORKDIR /root
CMD ["bash"]
