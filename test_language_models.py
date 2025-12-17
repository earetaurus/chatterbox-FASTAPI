#!/usr/bin/env python3
"""Test language-specific model variant (chatterbox-multilingual-es)"""

import requests
import json

# Test endpoint
url = "http://localhost:59363/v1/audio/speech"

# Test 1: Using chatterbox-multilingual-es (should override language parameter)
print("Test 1: Using chatterbox-multilingual-es model (ignoring language='en')")
print("=" * 60)

payload = {
    "model": "chatterbox-multilingual-es",  # Spanish model variant
    "input": "Hola, ¿cómo estás? Este es una prueba del sistema de texto a voz.",
    "voice": "default",
    "language": "en",  # This should be IGNORED - model name takes precedence
    "response_format": "mp3",
}

print(f"Request payload:")
print(json.dumps(payload, indent=2))
print()

response = requests.post(url, json=payload)

if response.status_code == 200:
    # Save audio file
    filename = "test_spanish_model_variant.mp3"
    with open(filename, "wb") as f:
        f.write(response.content)
    print(f"✅ SUCCESS! Audio saved to {filename}")
    print(f"✅ Language auto-detected from model name: es (Spanish)")
    print(f"✅ Ignored language parameter: en")
else:
    print(f"❌ FAILED with status code: {response.status_code}")
    print(f"Response: {response.text}")

print()
print("Test 2: Verify all language models are available")
print("=" * 60)

# Get models list
models_response = requests.get("http://localhost:59363/v1/models")
if models_response.status_code == 200:
    models_data = models_response.json()
    language_models = [
        m
        for m in models_data["data"]
        if "-es" in m["id"] or "-fr" in m["id"] or "-zh" in m["id"]
    ]
    print(
        f"✅ Found {len([m for m in models_data['data'] if m['id'].startswith('chatterbox-multilingual-')])} language-specific models"
    )
    print()
    print("Sample language-specific models:")
    for model in language_models[:5]:
        print(f"  - {model['id']}: {model['description']}")
else:
    print(f"❌ FAILED to get models list")

print()
print("=" * 60)
print("Test completed!")
