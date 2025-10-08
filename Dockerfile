FROM ubuntu:24.04

ENV MACHINE_NAME=vscode-remote

ARG TARGETARCH
ARG BUILD=stable

COPY src/* /usr/local/bin/

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    tzdata \
    curl ca-certificates \
    git build-essential && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    download_vscode $TARGETARCH $BUILD

WORKDIR /home/workspace

ENTRYPOINT [ "entrypoint" ]
