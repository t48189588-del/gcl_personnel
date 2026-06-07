FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install basic Linux dependencies & web utilities
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

USER vscode
WORKDIR /home/vscode

# Clone only the shallow single stable branch to save massive build time
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /home/vscode/flutter
ENV PATH="/home/vscode/flutter/bin:${PATH}"

# Configure the system specifically for web builds
RUN flutter config --enable-web && flutter doctor