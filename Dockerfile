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
    apt-get install -y \
        nodejs \
        gnupg lsb-release \
        bash-completion \
        openssh-client \
        nano \
        vim \
        less yq jq \
        tigervnc-standalone-server xfce4-session \
        wget nmap && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install claude code
RUN npm install -g @anthropic-ai/claude-code@latest

# install docker and docker compose CLI
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y \
        docker-ce-cli docker-compose-plugin \
    && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install zrok
RUN curl -sSLfo /tmp/zrok-install.bash https://get.openziti.io/install.bash && \
    bash /tmp/zrok-install.bash zrok && \
    rm /tmp/zrok-install.bash    

# configure sudo to be allowed for any user without password
#RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY src/* /usr/local/bin/
RUN download_vscode $TARGETARCH $BUILD

# install devcontainer CLI
RUN npm install -g @devcontainers/cli

# install NOVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.6.0.tar.gz | tar xz -C /opt && \
    mv /opt/noVNC-1.6.0 /opt/novnc

WORKDIR /home/workspace

#ENTRYPOINT [ "entrypoint" ]
CMD [ "entrypoint" ]
