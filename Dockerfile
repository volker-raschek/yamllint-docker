FROM docker.io/library/alpine:3.18.2 AS build

ARG YAMLLINT_VERSION=master

RUN set -ex && \
    apk update && \
    apk upgrade && \
    apk add git python3 py-pip

RUN git clone --branch ${YAMLLINT_VERSION} https://github.com/adrienverge/yamllint /tmp/yamllint && \
    python3 -m pip install /tmp/yamllint && \
    rm -rf /tmp/yamllint

WORKDIR /workspace

ENTRYPOINT [ "/usr/bin/yamllint" ]
