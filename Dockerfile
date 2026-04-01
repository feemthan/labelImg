# trunk-ignore-all(checkov/CKV_DOCKER_2)
FROM python:3.9-slim

# Install core dependencies that we know work
RUN apt-get update && apt-get install -y \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
    libqt5gui5t64 \
    libqt5widgets5t64 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    && rm -rf /var/lib/apt/lists/*

# Try to install optional Mesa packages (don't fail if unavailable)
RUN apt-get update && \
    (apt-get install -y libgl1 || true) && \
    (apt-get install -y mesa-utils || true) && \
    rm -rf /var/lib/apt/lists/*

# Install LabelImg via pip
RUN pip install --no-cache-dir labelimg

# Set working directory
WORKDIR /app

# Force software rendering with multiple fallback options
ENV QT_X11_NO_MITSHM=1 \
    QT_QUICK_BACKEND=software \
    LIBGL_ALWAYS_SOFTWARE=1 \
    LIBGL_ALWAYS_INDIRECT=1 \
    GALLIUM_DRIVER=llvmpipe \
    XDG_RUNTIME_DIR=/tmp/runtime-root

# Create runtime directory
RUN mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# Create user with same UID as host user
RUN useradd -m -u 1000 -s /bin/bash appuser
USER appuser

# Run LabelImg by default
CMD ["labelImg"]