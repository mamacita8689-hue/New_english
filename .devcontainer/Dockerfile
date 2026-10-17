FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter \
    && chown -R vscode:vscode /opt/flutter

USER vscode

RUN git config --global --add safe.directory /opt/flutter \
    && /opt/flutter/bin/flutter config --no-analytics \
    && /opt/flutter/bin/flutter precache --web

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"
