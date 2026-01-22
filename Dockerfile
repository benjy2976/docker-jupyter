# ===== Dockerfile (dev) =====
FROM jupyter/base-notebook:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

USER root
# System deps for common scientific/DB/image stacks
RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    libpq-dev \
    libgl1 \
    libglib2.0-0 \
    pkg-config \
    libcairo2-dev \
    tesseract-ocr \
    fonts-liberation \
    fonts-dejavu-core \
    libnss3 \
    libxss1 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libasound2 \
    libgbm1 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxfixes3 \
    libxi6 \
    unzip \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (stable) and matching ChromeDriver
RUN set -eux; \
    install -d /etc/apt/keyrings; \
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list; \
    apt-get update; \
    apt-get install -y google-chrome-stable; \
    rm -rf /var/lib/apt/lists/*; \
    chrome_version="$(google-chrome --version | awk '{print $3}')"; \
    curl -fsSL "https://storage.googleapis.com/chrome-for-testing-public/${chrome_version}/linux64/chromedriver-linux64.zip" -o /tmp/chromedriver.zip; \
    unzip -q /tmp/chromedriver.zip -d /tmp; \
    install -m 0755 /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver; \
    rm -rf /tmp/chromedriver*;

ENV CHROME_BIN=/usr/bin/google-chrome \
    CHROMEDRIVER_BIN=/usr/local/bin/chromedriver \
    PATH=/usr/local/bin:${PATH}

# Ensure chromedriver is discoverable on PATH for Selenium
RUN if ! command -v chromedriver >/dev/null 2>&1; then \
      ln -s /usr/local/bin/chromedriver /usr/bin/chromedriver; \
    fi

# Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt

# Entrypoint simple
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${NB_UID}

EXPOSE 8888
EXPOSE 5900
EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--ServerApp.token=", "--ServerApp.password=", "--ServerApp.root_dir=/app"]
