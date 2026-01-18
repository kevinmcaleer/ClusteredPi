# Custom Frigate build with HailoRT 5.1.1
# For Raspberry Pi 5 with AI HAT+ (Hailo-8L)
#
# Build: docker build -t frigate-hailo511 .
# 
# This Dockerfile patches the official Frigate image to use HailoRT 5.1.1
# instead of the bundled version (e.g., 4.21.0), to match the host driver.
#
# Check your host driver version with: modinfo hailo1x_pci | grep version
# The HAILO_VERSION below must match your host driver exactly.

ARG FRIGATE_VERSION=stable
FROM ghcr.io/blakeblackshear/frigate:${FRIGATE_VERSION}

# Set the HailoRT version to match your host driver
# Change this to match: modinfo hailo1x_pci | grep version
ARG HAILO_VERSION=5.1.1

# Architecture detection (aarch64 for Pi 5)
ARG TARGETARCH=arm64

LABEL maintainer="kevinmcaleer28"
LABEL description="Frigate NVR with HailoRT ${HAILO_VERSION} for Raspberry Pi AI HAT+"
LABEL hailo.version="${HAILO_VERSION}"

# Install HailoRT matching the specified version
# Downloads from Hailo's GitHub releases
RUN set -ex && \
    # Determine architecture string for downloads
    if [ "${TARGETARCH}" = "amd64" ]; then \
        ARCH="x86_64"; \
    elif [ "${TARGETARCH}" = "arm64" ]; then \
        ARCH="aarch64"; \
    else \
        echo "Unsupported architecture: ${TARGETARCH}" && exit 1; \
    fi && \
    \
    # Remove existing HailoRT wheel if present
    pip uninstall -y hailort 2>/dev/null || true && \
    \
    # Download and install HailoRT wheel from Hailo's releases
    # Note: frigate-nvr may host compatible builds, check their releases first
    WHEEL_URL="https://github.com/hailo-ai/hailort/releases/download/v${HAILO_VERSION}/hailort-${HAILO_VERSION}-cp311-cp311-linux_${ARCH}.whl" && \
    echo "Downloading HailoRT wheel from: ${WHEEL_URL}" && \
    pip install --no-cache-dir "${WHEEL_URL}" || \
    # Fallback: try frigate-nvr hosted builds
    pip install --no-cache-dir "https://github.com/frigate-nvr/hailort/releases/download/v${HAILO_VERSION}/hailort-${HAILO_VERSION}-cp311-cp311-linux_${ARCH}.whl" || \
    { echo "ERROR: Could not download HailoRT ${HAILO_VERSION} wheel. Check if this version exists."; exit 1; } && \
    \
    # Download and extract HailoRT runtime libraries
    TARBALL_URL="https://github.com/hailo-ai/hailort/releases/download/v${HAILO_VERSION}/hailort-${TARGETARCH}.tar.gz" && \
    echo "Downloading HailoRT tarball from: ${TARBALL_URL}" && \
    wget -qO- "${TARBALL_URL}" | tar -C / -xzf - || \
    # Fallback: try frigate-nvr hosted builds  
    wget -qO- "https://github.com/frigate-nvr/hailort/releases/download/v${HAILO_VERSION}/hailort-${TARGETARCH}.tar.gz" | tar -C / -xzf - || \
    { echo "WARNING: Could not download HailoRT tarball. Runtime libs may be missing."; } && \
    \
    # Verify installation
    python3 -c "import hailort; print(f'HailoRT version: {hailort.__version__}')" && \
    echo "HailoRT ${HAILO_VERSION} installed successfully"

# Ensure library path includes Hailo libs
ENV LD_LIBRARY_PATH="/usr/lib:${LD_LIBRARY_PATH}"
