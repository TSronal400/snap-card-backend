
import json
import base64
import urllib.request
import urllib.error

from fastapi import APIRouter, HTTPException, UploadFile, File
from pydantic import BaseModel, Field

from app.config import settings
from app.services.tcgdex_service import (
    search_tcgdex_cards,
    get_tcgdex_card_details,
    convert_eur_to_dop,
)

router = APIRouter(prefix="/ai", tags=["Inteligencia Artificial"])

GEMINI_MODEL = "gemini-3.5-flash-lite"


class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=1000)


class ChatResponse(BaseModel):
    reply: str


def ask_gemini(parts: list, json_mode: bool = False) -> str:
    api_key = (settings.gemini_api_key or "").strip()

    if not api_key:
        raise HTTPException(
            status_code=500,
            detail="La clave de Gemini no está configurada"
        )

    url = (
        "https://generativelanguage.googleapis.com/v1beta/"
        f"models/{GEMINI_MODEL}:generateContent"
    )

    payload = {
        "contents": [
            {
                "parts": parts
            }
        ]
    }

    if json_mode:
        payload["generationConfig"] = {
            "responseMimeType": "application/json",
            "thinkingConfig": {
                "thinkingLevel": "low"
            }
        }

    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "x-goog-api-key": api_key,
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=90) as response:
            result = json.loads(response.read().decode("utf-8"))

        candidates = result.get("candidates", [])

        if not candidates:
            raise HTTPException(
                status_code=502,
                detail="Gemini no pudo analizar la solicitud"
            )

        response_parts = (
            candidates[0].get("content", {}).get("parts", [])
        )

        answer = "\n".join(
            part["text"]
            for part in response_parts
            if "text" in part
        ).strip()

        if not answer:
            raise HTTPException(
                status_code=502,
                detail="Gemini no devolvió una respuesta"
            )

        return answer

    except urllib.error.HTTPError as error:
        error_detail = error.read().decode(
            "utf-8", errors="replace"
        )
        print("Error de Gemini:", error_detail)

        raise HTTPException(
            status_code=502,
            detail="Error al consultar Gemini"
        )

    except urllib.error.URLError as error:
        print("Error de conexión con Gemini:", error)

        raise HTTPException(
            status_code=503,
            detail="No se pudo conectar con Gemini"
        )


@router.post("/chat", response_model=ChatResponse)
def ai_chat(data: ChatRequest):
    prompt = data.message.strip()

    if not prompt:
        raise HTTPException(
            status_code=400,
            detail="El mensaje no puede estar vacío"
        )

    answer = ask_gemini([
        {
            "text": (
                "Eres el asistente de SNAP CARD, una aplicación "
                "para coleccionistas de Pokémon TCG. "
                "Responde en español de forma clara y amable. "
                "No inventes precios ni datos de cartas. "
                f"Pregunta del usuario: {prompt}"
            )
        }
    ])

    return ChatResponse(reply=answer)


@router.post("/scan")
async def scan_pokemon_card(
    image: UploadFile = File(...)
):
    allowed_types = [
        "image/jpeg",
        "image/png",
        "image/webp",
    ]

    if image.content_type not in allowed_types:
        raise HTTPException(
            status_code=400,
            detail="Solo se permiten imágenes JPG, PNG o WEBP"
        )

    image_bytes = await image.read()

    if not image_bytes:
        raise HTTPException(
            status_code=400,
            detail="La imagen está vacía"
        )

    if len(image_bytes) > 10 * 1024 * 1024:
        raise HTTPException(
            status_code=413,
            detail="La imagen no puede superar 10 MB"
        )

    encoded_image = base64.b64encode(
        image_bytes
    ).decode("utf-8")

    identification = ask_gemini(
        [
            {
                "text": (
                    "Analiza cuidadosamente esta fotografía de una "
                    "carta Pokémon TCG. "
                    "Identifica toda la información que puedas leer "
                    "directamente en la imagen. "
                    "Devuelve estos campos: "
                    "pokemon_name, card_number, set_name, rarity, "
                    "hp, card_type, attacks. "
                    "El número de colección debe conservar su formato "
                    "visible, por ejemplo 005/025. "
                    "No confundas el nombre del Pokémon con el nombre "
                    "de la carta. "
                    "No inventes información. "
                    "Si un dato no es legible, utiliza null. "
                    "Devuelve exclusivamente un JSON válido."
                )
            },
            {
                "inline_data": {
                    "mime_type": image.content_type,
                    "data": encoded_image,
                }
            }
        ],
        json_mode=True,
    )

    try:
        identification_data = json.loads(identification)
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=502,
            detail="No se pudo interpretar la identificación de Gemini"
        )

    pokemon_name = identification_data.get("pokemon_name")

    if not pokemon_name or not str(pokemon_name).strip():
        raise HTTPException(
            status_code=422,
            detail="No se pudo identificar el nombre de la carta"
        )

    card_number = identification_data.get("card_number")

    set_name = identification_data.get("set_name")

    try:
        cards = search_tcgdex_cards(str(pokemon_name))
    except Exception as error:
        print("Error buscando en TCGdex:", error)

        raise HTTPException(
            status_code=502,
            detail="No se pudo consultar el catálogo TCGdex"
        )

    if not cards:
        return {
            "identified": identification_data,
            "candidates": [],
            "message": "No se encontraron coincidencias en TCGdex"
        }

    # Priorizar coincidencias por número de colección.
    if card_number:
        target_number = str(card_number).split("/")[0].strip()
        target_number = target_number.lstrip("0") or "0"

        matching_cards = []

        for card in cards:
            local_id = str(card.get("localId", "")).strip()
            local_id = local_id.lstrip("0") or "0"

            if local_id == target_number:
                matching_cards.append(card)

        if matching_cards:
            cards = matching_cards + [
                card for card in cards
                if card not in matching_cards
            ]

    candidates = []

    # Obtener los detalles de hasta cinco resultados.
    for card in cards[:5]:
        card_id = card.get("id")

        if not card_id:
            continue

        try:
            details = get_tcgdex_card_details(str(card_id))

            set_info = details.get("set") or {}

            # Comprobar coincidencia del número.
            number_matches = False

            if card_number:
                target_number = str(card_number).split("/")[0].strip()
                target_number = target_number.lstrip("0") or "0"

                local_number = str(
                    details.get("localId", card.get("localId", ""))
                ).strip()

                local_number = local_number.lstrip("0") or "0"

                number_matches = local_number == target_number

            # Comprobar coincidencia de expansión.
            set_matches = False

            if set_name:
                expected_set = str(set_name).strip().lower()
                actual_set = str(set_info.get("name", "")).strip().lower()

                if expected_set and actual_set == expected_set:
                    set_matches = True

            pricing = details.get("pricing") or {}
            cardmarket = pricing.get("cardmarket") or {}

            price_eur = cardmarket.get("avg")

            if price_eur is None:
                for variant in details.get("variants_detailed") or []:
                    variant_pricing = variant.get("pricing") or {}
                    variant_cardmarket = (
                        variant_pricing.get("cardmarket") or {}
                    )

                    price_eur = variant_cardmarket.get("avg")

                    if price_eur is not None:
                        break

            price_dop = None

            if price_eur is not None:
                try:
                    price_dop = convert_eur_to_dop(price_eur)
                except Exception as error:
                    print("Error convirtiendo el precio:", error)

            candidates.append({
                "id": details.get("id", card_id),
                "name": details.get("name", card.get("name")),
                "image": details.get("image", card.get("image")),
                "local_id": details.get("localId"),
                "category": details.get("category"),
                "rarity": details.get("rarity"),
                "hp": details.get("hp"),
                "types": details.get("types") or [],
                "stage": details.get("stage"),
                "illustrator": details.get("illustrator"),
                "set_id": set_info.get("id"),
                "set_name": set_info.get("name"),
                "price_eur": price_eur,
                "price_dop": price_dop,
                "_number_matches": number_matches,
                "_set_matches": set_matches,
            })

        except Exception as error:
            print(
                f"Error obteniendo detalles de {card_id}:",
                error
            )

    # Mostrar primero las cartas que coincidan con número y expansión.
    candidates.sort(
        key=lambda item: (
            item["_number_matches"] and item["_set_matches"],
            item["_number_matches"],
            item["_set_matches"],
        ),
        reverse=True
    )

    # Eliminar los campos internos antes de enviar la respuesta.
    for candidate in candidates:
        candidate.pop("_number_matches")
        candidate.pop("_set_matches")

    return {
        "identified": identification_data,
        "candidates": candidates,
        "message": (
            "Búsqueda completada"
            if candidates
            else "No se pudieron obtener los detalles de las cartas"
        )
    }
