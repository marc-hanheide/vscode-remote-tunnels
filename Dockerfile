FROM ubuntu:24.04

ENV MACHINE_NAME=vscode-remote

ARG TARGETARCH
ARG BUILD=stable

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    tzdata \
    iputils-ping \
    sudo \
    curl ca-certificates \
    git build-essential && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# install node 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install claude code
RUN npm install -g @anthropic-ai/claude-code@latest

RUN apt-get update && apt-get install -y \
        bash-completion \
        openssh-client \
        wget nmap && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# configure sudo to be allowed for any user without password
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY src/* /usr/local/bin/
RUN download_vscode $TARGETARCH $BUILD


WORKDIR /home/workspace

ENTRYPOINT [ "entrypoint" ]
