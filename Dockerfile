FROM docker.io/library/python:3.13.2-alpine AS build

ARG YAMLLINT_VERSION=master

RUN set -ex && \
    apk update && \
    apk upgrade && \
    apk add git python3 py-pip

RUN git clone --branch ${YAMLLINT_VERSION} https://github.com/adrienverge/yamllint /tmp/yamllint && \
    python3 -m venv /venv && \
    /venv/bin/pip3 install /tmp/yamllint && \
    rm -r -f /tmp/yamllint

ENV PATH="/venv/bin:${PATH}"

WORKDIR /workspace

ENTRYPOINT [ "yamllint" ]
