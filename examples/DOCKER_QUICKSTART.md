# Example: Quick Start with Docker

This example demonstrates how to quickly get Chatterbox FastAPI running with Docker.

## Step 1: Clone the Repository

```bash
git clone https://github.com/groxaxo/chatterbox-FASTAPI.git
cd chatterbox-FASTAPI
```

## Step 2: (Optional) Configure Environment Variables

Create a `.env` file in the project root:

```env
# Server Configuration
PORT=8000

# TTS Model Settings - Adjust these for different voice characteristics
CHATTERBOX_TEMPERATURE=0.5      # Lower = more stable, Higher = more varied
CHATTERBOX_CFG_WEIGHT=0.35      # Classifier-free guidance weight
CHATTERBOX_EXAGGERATION=1.0     # Voice expressiveness level
```

## Step 3: Start with Docker Compose

```bash
docker-compose up -d
```

This will:
- Build the Docker image with all dependencies
- Download the Chatterbox multilingual model (~500MB+) on first run
- Start the FastAPI server on port 8000
- Set up persistent volume for model caching

## Step 4: Verify It's Running

Check the logs:
```bash
docker-compose logs -f
```

You should see output like:
```
chatterbox-fastapi | ╔═══════════════════════════════════════════════════════════════╗
chatterbox-fastapi | ║                                                               ║
chatterbox-fastapi | ║    ╔═╗╦ ╦╔═╗╔╦╗╔╦╗╔═╗╦═╗╔╗ ╔═╗═╗ ╦                          ║
chatterbox-fastapi | ║    ║  ╠═╣╠═╣ ║  ║ ║╣ ╠╦╝╠╩╗║ ║╔╩╦╝                          ║
chatterbox-fastapi | ║    ╚═╝╩ ╩╩ ╩ ╩  ╩ ╚═╝╩╚═╚═╝╚═╝╩ ╚═                          ║
chatterbox-fastapi | ║         FastAPI - OpenAI Compatible TTS                      ║
chatterbox-fastapi | ║                                                               ║
chatterbox-fastapi | ╚═══════════════════════════════════════════════════════════════╝
chatterbox-fastapi | Server ready!
```

## Step 5: Access the Application

Open your browser to:

- **Web Demo**: http://localhost:8000
  - Beautiful UI to test TTS with 23+ languages
  - No coding required!
  
- **API Documentation**: http://localhost:8000/docs
  - Interactive Swagger UI
  - Test all endpoints
  
- **Health Check**: http://localhost:8000/health
  - Verify server status

## Step 6: Test the API

### Using the Web Interface

1. Go to http://localhost:8000
2. Enter text in any of 23 supported languages
3. Select the language from the dropdown
4. Click "Generate Speech"
5. Listen and download!

### Using Python

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="not-needed"
)

# Generate English speech
response = client.audio.speech.create(
    model="chatterbox-multilingual",
    voice="default",
    input="Hello! This is Chatterbox FastAPI running in Docker.",
    language="en"
)

response.stream_to_file("output.mp3")
```

### Using curl

```bash
curl -X POST "http://localhost:8000/v1/audio/speech" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "chatterbox-multilingual",
    "input": "Hello from Docker!",
    "voice": "default",
    "language": "en"
  }' \
  --output output.mp3
```

## Stopping the Service

```bash
docker-compose down
```

## Troubleshooting

### Issue: Port 8000 already in use
**Solution**: Change the port in `.env` or `docker-compose.yml`:
```yaml
ports:
  - "8080:8000"  # Use port 8080 instead
```

### Issue: Models downloading slowly
**Solution**: This is normal for the first run. The models (~500MB+) are cached in a Docker volume, so subsequent starts will be much faster.

### Issue: Out of memory
**Solution**: 
- For CPU: Increase Docker memory allocation to 8GB+ in Docker Desktop settings
- For GPU: Ensure you have at least 4GB VRAM available

## Next Steps

- Try different languages in the web demo
- Integrate with your application using the OpenAI-compatible API
- Configure custom voices by adding samples to the `voice_samples` directory
- Enable GPU support for faster generation (see main README)

For more examples, see the main README.md and test_api.py files.
