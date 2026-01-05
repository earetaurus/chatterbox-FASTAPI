# Multi-stage Dockerfile for Chatterbox FastAPI
# Stage 1: Base image with dependencies
FROM python:3.11-slim as base

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Builder stage
FROM base as builder

# Copy project files
COPY pyproject.toml ./
COPY src/ ./src/
COPY api/ ./api/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e .

# Stage 3: Runtime stage
FROM base as runtime

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY src/ /app/src/
COPY api/ /app/api/
COPY pyproject.toml /app/

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
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Run the application
CMD ["python", "-m", "api.main"]
