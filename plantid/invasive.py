import json
import httpx
import os
from typing import Dict, Any
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Configure the API key from environment variable
API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise ValueError("GEMINI_API_KEY not found in environment variables. Please set it in .env file.")

MODEL_NAME = "gemini-2.0-flash"
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL_NAME}:generateContent?key={API_KEY}"

class InvasiveChecker:
    def __init__(self):
        self.client = httpx.AsyncClient(timeout=30.0)

    async def check_invasive(self, plant_name: str, location: str) -> Dict[str, Any]:
        """
        Check if a plant is invasive in a specific location using Gemini REST API.
        """
        if not location:
            return {
                "is_invasive": False,
                "severity": "Unknown",
                "reason": "No location provided."
            }

        prompt = (
            f"Is the plant '{plant_name}' considered an invasive species in '{location}'? "
            "Please provide the answer strictly in JSON format with the following keys: "
            "'is_invasive' (boolean), 'severity' (string: High, Medium, Low, or None), "
            "and 'reason' (string, concise explanation in the same language as the location if possible, else English). "
            "Do not include any markdown formatting like ```json."
        )

        payload = {
            "contents": [{
                "parts": [{"text": prompt}]
            }]
        }

        try:
            response = await self.client.post(API_URL, json=payload)
            response.raise_for_status()
            
            data = response.json()
            # Extract text from response structure
            # { "candidates": [ { "content": { "parts": [ { "text": "..." } ] } } ] }
            try:
                text = data["candidates"][0]["content"]["parts"][0]["text"].strip()
            except (KeyError, IndexError) as e:
                print(f"Unexpected API response structure: {data}")
                return {
                    "is_invasive": False,
                    "severity": "Error",
                    "reason": "Unexpected response from AI service."
                }

            # Remove markdown code blocks if present
            if text.startswith("```json"):
                text = text[7:]
            if text.startswith("```"):
                text = text[3:]
            if text.endswith("```"):
                text = text[:-3]
            
            result = json.loads(text.strip())
            return result
        except Exception as e:
            print(f"Error checking invasive species: {e}")
            return {
                "is_invasive": False,
                "severity": "Error",
                "reason": f"Failed to verify with AI service: {str(e)}"
            }

    async def close(self):
        await self.client.aclose()
