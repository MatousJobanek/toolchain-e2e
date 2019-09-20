FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

ENV OPERATOR=/usr/local/bin/toolchain-e2e \
    USER_UID=1001 \
    USER_NAME=toolchain-e2e \
    LANG=en_US.utf8


ENV LANG=en_US.utf8 \
    GOPATH=/tmp/go \
    GOCACHE=/tmp/.cache \
    PATH=$PATH:$GOPATH/bin \
    GIT_COMMITTER_NAME=devtools \
    GIT_COMMITTER_EMAIL=devtools@redhat.com \
    OPERATOR_SDK_VERSION=v0.10.0

ARG GO_PACKAGE_PATH=github.com/codeready-toolchain/toolchain-e2e

RUN yum install epel-release -y \
    && yum install --enablerepo=centosplus install -y --quiet \
    findutils \
    git \
    golang \
    make \
    procps-ng \
    tar \
    wget \
    which \
    bc \
    kubectl \
    yamllint \
    python36-virtualenv \
    jq \
    && yum clean all

RUN mkdir -p ${GOPATH}/src/${GO_PACKAGE_PATH}/

# install operator binary
COPY script/clone_build_run_operator.sh ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

WORKDIR ${GOPATH}/src/${GO_PACKAGE_PATH}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}
