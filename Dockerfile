# ===== Dockerfile (dev) =====
FROM jupyter/base-notebook:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

USER root
# System deps for common scientific/DB/image stacks
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libgl1 \
    libglib2.0-0 \
    pkg-config \
    libcairo2-dev \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt

# Entrypoint simple
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${NB_UID}

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--ServerApp.token=", "--ServerApp.password=", "--ServerApp.root_dir=/app"]
