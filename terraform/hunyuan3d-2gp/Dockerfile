# Hunyuan3D-2GP API Server Dockerfile for Azure Container Instances
# This builds a production-ready container for the Hunyuan3D-2GP 3D generation API

FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

LABEL maintainer="Azure Deployment"
LABEL description="Hunyuan3D-2GP 3D Generation API Server"
LABEL version="1.0"

WORKDIR /app

# Install system dependencies including git for model downloads
RUN apt-get update && \
    apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-venv \
    g++ \
    make \
    git \
    wget \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set python3.10 as default python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Set environment variables for better Python behavior and caching
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV HF_HOME=/app/.cache/huggingface
ENV TORCH_HOME=/app/.cache/torch

# Clone and setup Hunyuan3D-2GP from source
RUN git clone https://github.com/Tencent/Hunyuan3D-2GP.git /app && \
    cd /app

# Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu121 && \
    python3 -m pip install --no-cache-dir -r requirements.txt

# Install the package itself
RUN python3 -m pip install -e .

# Create cache directories for models and gradio
RUN mkdir -p /app/.cache/huggingface /app/.cache/torch /app/gradio_cache

# Create non-root user for security (after installation)
RUN useradd -m -u 1001 hunyuan && \
    chown -R hunyuan:hunyuan /app
USER hunyuan

# Health check endpoint (using existing status endpoint pattern)
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Expose the API port
EXPOSE 8081

# Default command with production settings optimized for Azure Container Instances
CMD ["python3", "api_server.py", \
     "--host", "0.0.0.0", \
     "--port", "8081", \
     "--model_path", "tencent/Hunyuan3D-2mini", \
     "--tex_model_path", "tencent/Hunyuan3D-2", \
     "--device", "cuda", \
     "--limit-model-concurrency", "2", \
     "--enable_tex"]