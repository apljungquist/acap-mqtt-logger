ARG REPO=axisecp
ARG SDK=acap-native-sdk
ARG UBUNTU_VERSION=22.04
ARG VERSION=1.15
FROM --platform=linux/amd64 ${REPO}/${SDK}:${VERSION}-aarch64-ubuntu${UBUNTU_VERSION} AS sdk-aarch64
FROM --platform=linux/amd64 ${REPO}/${SDK}:${VERSION}-armv7hf-ubuntu${UBUNTU_VERSION} AS sdk-armv7hf

FROM --platform=linux/amd64 rust:1.86.0-bullseye

COPY --from=sdk-aarch64 /opt/axis/acapsdk/sysroots/aarch64 /opt/axis/acapsdk/sysroots/aarch64
COPY --from=sdk-armv7hf /opt/axis/acapsdk/sysroots/armv7hf /opt/axis/acapsdk/sysroots/armv7hf

RUN apt-get update \
 && apt-get install \
    --assume-yes \
    --no-install-recommends \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    g++-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf \
    git \
    libglib2.0-dev \
    libssl-dev \
    pkg-config

COPY rust-toolchain.toml ./
# Consider using `--rev` with a commit ID instead of a tag to protect against supply chain attacks.
RUN rustup show \
  && rm rust-toolchain.toml
