FROM debian:stable-slim

# SIGUSR1 causes veloren-server-cli to initiate a graceful shutdown
LABEL com.centurylinklabs.watchtower.stop-signal="SIGUSR1"

ARG PROJECTNAME=server-cli

# librust-backtrace+libbacktrace-dev = backtrace functionality
# iproute2 and net-tools for diagnostic purposes
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends --assume-yes \
        ca-certificates \
        librust-backtrace+libbacktrace-dev \
        iproute2 \
        net-tools \
    && rm -rf /var/lib/apt/lists/*;

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY ./veloren-server-cli /home/container/veloren-server-cli
COPY ./assets/common /home/container/assets/common
COPY ./assets/server /home/container/assets/server
COPY ./assets/world /home/container/assets/world

ENV RUST_BACKTRACE=full
ENTRYPOINT ["/home/container/veloren-server-cli"]
