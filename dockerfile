FROM debian:stable-slim

LABEL maintainer="your-name"
LABEL description="Network inspection toolkit for Kubernetes debugging"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    # HTTP clients
    curl \
    wget \
    # ICMP / routing
    iputils-ping \
    traceroute \
    mtr \
    # DNS
    dnsutils \
    # Port scanning
    nmap \
    # Packet capture
    tcpdump \
    # Socket / connection inspection
    net-tools \
    iproute2 \
    # Bandwidth testing
    iperf3 \
    # Netcat
    netcat-openbsd \
    # Extras — useful in practice
    procps \
    ca-certificates \
    less \
    vim-tiny \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Drop to a non-root user by default.
# Override with --privileged + -u root when tcpdump / raw sockets are needed.
RUN useradd -m -s /bin/bash netdebug
USER netdebug
WORKDIR /home/netdebug

CMD ["/bin/bash"]
