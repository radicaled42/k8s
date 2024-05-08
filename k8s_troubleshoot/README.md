# All-In-One Kubernetes tools (kubectl, helm, iam-authenticator, eksctl, kubeseal, etc)

kubernetes docker images with necessary tools

## How to build the image

The original repo comes with a build.sh to generate the docker image. But as I don't have circleci or actions enables there was no use.  
To build the image you can use the command below.

```
docker build --no-cache --build-arg KUBECTL_VERSION=${tag} --build-arg HELM_VERSION=${helm} --build-arg KUSTOMIZE_VERSION=${kustomize_version} -t ${image}:${tag} .
```

You can run the build command without arguments and it will install the follwing versions:

- HELM_VERSION=3.11.1
- KUBECTL_VERSION=1.27.0
- KUSTOMIZE_VERSION=v5.0.1
- KUBESEAL_VERSION=0.18.1
- HELMFILE_VERSION=0.152.0

### Notes

(1) For AWS EKS users, not all versions are supported yet. [AWS EKS](https://aws.amazon.com/eks) maintains [special kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) to its managed service. Do remember to choice the proper version for EKS only.

(2) There is no `latest` tag for this image

(3) If you need more tools to be added, raise tickets in issues.

(4) This image supports `linux/amd64,linux/arm64` platforms now, updated on 15th Feb 2023 with [#54](https://github.com/alpine-docker/k8s/pull/54)

### Installed tools

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (latest minor versions: https://kubernetes.io/releases/)
- [kustomize](https://github.com/kubernetes-sigs/kustomize) (latest release: https://github.com/kubernetes-sigs/kustomize/releases/latest)
- [helm](https://github.com/helm/helm) (latest release: https://github.com/helm/helm/releases/latest)
- [helm-diff](https://github.com/databus23/helm-diff) (latest commit)
- [helm-unittest](https://github.com/helm-unittest/helm-unittest) (latest commit)
- [helm-push](https://github.com/chartmuseum/helm-push) (latest commit)
- [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) (latest version when run the build)
- [eksctl](https://github.com/weaveworks/eksctl) (latest version when run the build)
- [awscli v2](https://github.com/aws/aws-cli) (awscli v2 the image gets bigger due to the awscli v2 issue)
- [helmfile](https://github.com/roboll/helmfile) (latest version when run the build)
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets) (latest version when run the build)
- General tools, such as bash, curl, jq, yq, etc

### Github Repo

https://github.com/radicaled42/k8s

#### Original

- https://github.com/alpine-docker/k8s

### AWS Cli v2 Issue information

- https://github.com/aws/aws-cli/issues/4685#issuecomment-1441909537
- https://github.com/kyleknap/aws-cli/blob/source-proposal/proposals/source-install.md#alpine-linux
- https://stackoverflow.com/questions/60298619/awscli-version-2-on-alpine-linux

# Why we need it

Mostly it is used during CI/CD (continuous integration and continuous delivery) or as part of an automated build/deployment

# kubectl versions

You should check in [kubernetes versions](https://kubernetes.io/releases/), it lists the kubectl latest minor versions and used as image tags.

# Involve with developing and testing

If you want to build these images by yourself, please follow below commands.

```
export REBUILD=true
# comment the line in file "build.sh" to stop image push:  docker push ${image}:${tag}
bash ./build.sh
```

Second thinking, if you are adding a new tool, make sure it is supported in both `linux/amd64,linux/arm64` platforms

### Weekly build

Automation build job runs weekly by Circle CI Pipeline.
