# Build awscli v2 biaries
FROM python:3.10-alpine as builder

ENV AWSCLI_VERSION=2.11.4

RUN apk add --no-cache \
    curl \
    make \
    cmake \
    gcc \
    g++ \
    libc-dev \
    libffi-dev \
    openssl-dev \
    groff \
    && curl https://awscli.amazonaws.com/awscli-${AWSCLI_VERSION}.tar.gz | tar -xz \
    && cd awscli-${AWSCLI_VERSION} \
    && ./configure --prefix=/usr/local/lib/aws-cli/ --with-download-deps \
    && make \
    && make install

###

FROM alpine

ARG ARCH

# Ignore to update versions here
# docker build --no-cache --build-arg KUBECTL_VERSION=${tag} --build-arg HELM_VERSION=${helm} --build-arg KUSTOMIZE_VERSION=${kustomize_version} -t ${image}:${tag} .
ARG HELM_VERSION=3.11.1
ARG KUBECTL_VERSION=1.27.0
ARG KUSTOMIZE_VERSION=v5.0.1
ARG KUBESEAL_VERSION=0.18.1
ARG HELMFILE_VERSION=0.152.0

# Install helm (latest release)
# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
RUN case `uname -m` in \
    x86_64) ARCH=amd64; ;; \
    armv7l) ARCH=arm; ;; \
    aarch64) ARCH=arm64; ;; \
    ppc64le) ARCH=ppc64le; ;; \
    s390x) ARCH=s390x; ;; \
    *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    echo "export ARCH=$ARCH" > /envfile && \
    cat /envfile

# Install helm
RUN . /envfile && echo $ARCH && \
    apk add --update --no-cache curl ca-certificates bash git && \
    curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar -xvz && \
    mv linux-${ARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${ARCH}

# Install helmfile
RUN . /envfile && echo $ARCH && \
    apk add --update --no-cache curl ca-certificates bash git && \
    curl -sL https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_${ARCH}.tar.gz | tar -xvz && \
    mv helmfile /usr/bin/helmfile && \
    chmod +x /usr/bin/helmfile && \
    rm -rf LICENSE README-zh_CN.md README.md

# add helm-diff
RUN helm plugin install https://github.com/databus23/helm-diff && rm -rf /tmp/helm-*

# add helm-unittest
RUN helm plugin install https://github.com/helm-unittest/helm-unittest && rm -rf /tmp/helm-*

# add helm-push
RUN helm plugin install https://github.com/chartmuseum/helm-push && \
    rm -rf /tmp/helm-* \
    /root/.local/share/helm/plugins/helm-push/testdata \
    /root/.cache/helm/plugins/https-github.com-chartmuseum-helm-push/testdata

# Install kubectl
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install kustomize (latest release)
RUN . /envfile && echo $ARCH && \
    curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz && \
    tar xvzf kustomize_${KUSTOMIZE_VERSION}_linux_${ARCH}.tar.gz && \
    mv kustomize /usr/bin/kustomize && \
    chmod +x /usr/bin/kustomize

# Install eksctl (latest version)
RUN . /envfile && echo $ARCH && \
    curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${ARCH}.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/bin && \
    chmod +x /usr/bin/eksctl

# Install jq
RUN apk add --update --no-cache jq yq

# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
# Install aws-iam-authenticator (latest version)
RUN . /envfile && echo $ARCH && \
    authenticator=$(curl -fs https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest | jq --raw-output '.name' | sed 's/^v//') && \
    curl -fL https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${authenticator}/aws-iam-authenticator_${authenticator}_linux_${ARCH} -o /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

# Install for envsubst
RUN apk add --update --no-cache gettext

# Install kubeseal
RUN . /envfile && echo $ARCH && \
    curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-${ARCH}.tar.gz -o - | tar xz -C /usr/bin/ && \
    chmod +x /usr/bin/kubeseal

# Install awscli
RUN apk add --update --no-cache groff
RUN apk add --update --no-cache python3 && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
#    pip3 install --upgrade pip && \
#    pip3 install awscli && \
    pip3 cache purge
COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/
RUN ln -s /usr/local/lib/aws-cli/bin/aws /usr/bin/aws

WORKDIR /apps
