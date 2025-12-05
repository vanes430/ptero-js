FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL author="Vanes" maintainer="vanessimbolon2020@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/vanes430/ptero-js"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.description="Pterodactyl Node.js multi-runtime image with Bun, NVM (Node 18/20/22/24), Yarn, PNPM, and optimized Debian bookworm-slim base."

# --- Install dependencies ---
RUN apt-get update && apt-get install -y \
    curl wget git bash ca-certificates \
    build-essential zip unzip tar ffmpeg jq procps \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# --- Install Bun ---
RUN curl -fsSL https://bun.sh/install | bash && \
    mv /root/.bun /opt/bun && \
    ln -s /opt/bun/bin/bun /usr/local/bin/bun

ENV BUN_INSTALL="/opt/bun"
ENV PATH="/opt/bun/bin:${PATH}"

# --- Install NVM in safe location ---
ENV NVM_DIR="/opt/nvm"
RUN mkdir -p /opt/nvm && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# --- Install multiple Node.js versions ---
RUN bash -c "export NVM_DIR=/opt/nvm && \
    source /opt/nvm/nvm.sh && \
    nvm install 18 && \
    nvm install 20 && \
    nvm install 22 && \
    nvm install 24 && \
    nvm alias default 20"

# --- Fix: Ensure NVM loads for non-root users (critical patch) ---
RUN echo 'export NVM_DIR="/opt/nvm"' >> /etc/profile.d/nvm.sh && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /etc/profile.d/nvm.sh && \
    chmod +x /etc/profile.d/nvm.sh

# --- Ensure default Node version is available in PATH ---
ENV PATH="/opt/nvm/versions/node/v20.0.0/bin:${PATH}"

# --- Install Yarn & PNPM globally ---
RUN bash -c "export NVM_DIR=/opt/nvm && \
    source /opt/nvm/nvm.sh && \
    nvm use default && \
    npm install -g yarn pnpm"

# --- Add Pterodactyl user ---
RUN useradd -m -d /home/container container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# --- Copy entrypoint ---
COPY --chmod=755 ./../entrypoint.sh /entrypoint.sh

CMD [ "/bin/bash", "/entrypoint.sh" ]
