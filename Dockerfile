# Dockerfile for Chatterbox FastAPI
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY pyproject.toml ./
COPY src/ ./src/
COPY api/ ./api/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e .

# Create directory for voice samples
RUN mkdir -p /app/voice_samples

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV CHATTERBOX_TEMPERATURE=0.5
ENV CHATTERBOX_CFG_WEIGHT=0.35
ENV CHATTERBOX_EXAGGERATION=1.0

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Run the application
CMD ["python", "-m", "api.main"]
