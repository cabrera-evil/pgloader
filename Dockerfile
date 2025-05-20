# -------- Build Stage --------
# Use slim Debian base for a minimal build environment
FROM debian:bookworm-slim AS builder

# Pull Request version to build from
ARG VERSION=1531

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies (for building pgloader)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    freetds-dev \
    gawk \
    git \
    libsqlite3-dev \
    libssl3 \
    libzip-dev \
    make \
    openssl \
    patch \
    sbcl \
    time \
    unzip \
    wget \
    cl-ironclad \
    cl-babel && \
    # Create the source directory
    mkdir -p /opt/src/pgloader && \
    # Clean up APT cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# Set working directory for build
WORKDIR /opt/src/pgloader

# Download the specific pull request source tarball from GitHub and extract it
RUN wget -O /tmp/pgloader.tar.gz \
    -L "https://api.github.com/repos/dimitri/pgloader/tarball/pull/$VERSION/head" && \
    tar -xzf /tmp/pgloader.tar.gz --strip-components=1 -C . && \
    rm /tmp/pgloader.tar.gz

# Compile pgloader with extended dynamic space
RUN make DYNSIZE=32768 clones save

# -------- Runtime Stage --------
# Start again from a clean base image for the final runtime image
FROM debian:bookworm-slim

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies required by pgloader
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    freetds-dev \
    gawk \
    libsqlite3-dev \
    libzip-dev \
    sbcl \
    unzip && \
    # Clean up APT cache
    rm -rf /var/lib/apt/lists/*

# Copy only the built binary from the builder stage
COPY --from=builder /opt/src/pgloader/build/bin/pgloader /usr/local/bin/pgloader

# Default working directory for pgloader execution
WORKDIR /data

# Run pgloader as the default command
ENTRYPOINT ["pgloader"]
