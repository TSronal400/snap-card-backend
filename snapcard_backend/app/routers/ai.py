import os
import json
import urllib.request
from typing import Optional
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

router = APIRouter(prefix="/ai", tags=["Inteligencia Artificial"])

class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=1000)

class ChatResponse(BaseModel):
    reply: str

def generate_local_expert_response(prompt: str) -> str:
    lowered = prompt.lower()

    if any(k in lowered for k in ["charizard", "fuego"]):
        return (
            "🔥 **Charizard Fuego Divino**: Es una de las cartas más codiciadas del mercado TCG. "
            "Su valor estimado en condición Mint/PSA 10 oscila entre $350 y $1,200 USD dependiendo de la edición (1st Edition vs Unlimited). "
            "Recomendación: Guárdala en un sleeve protector rígido para preservar sus bordes."
        )
    elif any(k in lowered for k in ["precio", "valor", "cuanto vale", "costo"]):
        return (
            "💰 **Estimación de Precios de Mercado**: "
            "• **Legendarias** (Charizard, Mewtwo): $300 - $500+ USD\n"
            "• **Épicas** (Blastoise, Gyarados): $80 - $150 USD\n"
            "• **Raras** (Bosque Antiguo, Gengar): $25 - $75 USD\n"
            "Para un cálculo exacto, asegúrate de verificar la condición física (Centrado, Esquinas, Superficie y Bordes)."
        )
    elif any(k in lowered for k in ["falsa", "autenticidad", "real", "fake", "original"]):
        return (
            "🔍 **Consejos de Autenticidad para Cartas**: "
            "1. **Prueba de luz**: Pasa la linterna de tu celular por detrás; si la luz atraviesa fácilmente, puede ser una imitación.\n"
            "2. **Textura del holograma**: Las cartas originales tienen un relieve rugoso y detallado en la superficie.\n"
            "3. **Fuente e impresión**: Revisa la tipografía del texto y la nitidez de los símbolos de energía."
        )
    elif any(k in lowered for k in ["pikachu", "mewtwo", "blastoise", "venusaur"]):
        return (
            "⚡ **Carta Destacada**: Las ediciones especiales como Pikachu Trueno Dorado ($220 USD) "
            "y Mewtwo Psíquico Supremo ($420 USD) tienen alta demanda entre coleccionistas por su bajo tiraje de impresión."
        )
    elif any(k in lowered for k in ["hola", "buenos dias", "buenas noches", "saludos"]):
        return (
            "👋 ¡Hola Coleccionista! Soy la IA de Snap Card. "
            "¿Qué duda tienes sobre tus cartas, precios del mercado o consejos de colección?"
        )
    else:
        return (
            f"✨ **Asistente IA Snap Card**: He analizado tu consulta sobre '{prompt}'. "
            "En el mercado TCG, el valor de cada carta se determina por su rareza, la edición del set "
            "y el estado de conservación (PSA/BGS). ¡Puedes preguntarme sobre el precio de Charizard, Pikachu o consejos para autenticar cartas!"
        )

@router.post("/chat", response_model=ChatResponse)
def ai_chat(data: ChatRequest):
    prompt = data.message.strip()
    if not prompt:
        raise HTTPException(status_code=400, detail="El mensaje no puede estar vacío")

    gemini_key = os.getenv("GEMINI_API_KEY")

    if gemini_key:
        try:
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={gemini_key}"
            payload = {
                "contents": [
                    {
                        "parts": [
                            {
                                "text": (
                                    "Eres el Asistente IA oficial de la aplicación SNAP CARD para coleccionistas de cartas TCG. "
                                    "Responde de forma amable, precisa, concisa y estructurada en español. "
                                    f"Pregunta del usuario: {prompt}"
                                )
                            }
                        ]
                    }
                ]
            }
            req = urllib.request.Request(
                url,
                data=json.dumps(payload).encode("utf-8"),
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            with urllib.request.urlopen(req, timeout=8) as response:
                result = json.loads(response.read().decode("utf-8"))
                candidates = result.get("candidates", [])
                if candidates:
                    parts = candidates[0].get("content", {}).get("parts", [])
                    if parts and "text" in parts[0]:
                        return ChatResponse(reply=parts[0]["text"].strip())
        except Exception as e:
            print(f"Error consultando Gemini API: {e}")

    # Respuesta experta generada
    reply = generate_local_expert_response(prompt)
    return ChatResponse(reply=reply)
