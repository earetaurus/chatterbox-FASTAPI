# Docker Testing Guide

This guide helps you test the Docker setup locally.

## Prerequisites

- Docker installed (https://docs.docker.com/get-docker/)
- Docker Compose installed (usually comes with Docker Desktop)
- For GPU support: nvidia-docker (https://github.com/NVIDIA/nvidia-docker)

## Quick Test

### Using Docker Compose (Recommended)

```bash
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

### Using Docker directly

```bash
# Build the image
docker build -t chatterbox-fastapi .

# Run the container
docker run -p 8000:8000 chatterbox-fastapi

# Run with custom settings
docker run -p 8000:8000 \
  -e CHATTERBOX_TEMPERATURE=0.7 \
  -e CHATTERBOX_CFG_WEIGHT=0.5 \
  -v $(pwd)/voice_samples:/app/voice_samples \
  chatterbox-fastapi
```

## Verify Installation

Once the container is running, test these endpoints:

```bash
# Health check
curl http://localhost:8000/health

# Web demo
open http://localhost:8000

# API docs
open http://localhost:8000/docs
```

## GPU Support

To enable GPU support:

1. Install nvidia-docker
2. Uncomment GPU sections in `docker-compose.yml`
3. Run: `docker-compose up -d`

Or with Docker directly:

```bash
docker run --gpus all -p 8000:8000 chatterbox-fastapi
```

## Troubleshooting

### Models not downloading
The first run will download ~500MB+ of models. Be patient and check the logs:
```bash
docker-compose logs -f
```

### Port already in use
Change the port in `docker-compose.yml` or use:
```bash
docker run -p 8080:8000 chatterbox-fastapi
```

### Permission issues with voice_samples
Make sure the directory is writable:
```bash
chmod 755 voice_samples
```
