import json
from urllib.request import Request, urlopen
from urllib.parse import urlencode

TCGDEX_URL = "https://api.tcgdex.net/v2/es/cards"


def search_tcgdex_cards(name: str):
    params = urlencode({"name": name})
    url = f"{TCGDEX_URL}?{params}"

    request = Request(
        url,
        headers={"User-Agent": "SnapCard/1.0"}
    )

    with urlopen(request, timeout=20) as response:
        return json.loads(response.read().decode("utf-8"))


def get_tcgdex_card_details(card_id: str):
    url = f"{TCGDEX_URL}/{card_id}"

    request = Request(
        url,
        headers={"User-Agent": "SnapCard/1.0"}
    )

    with urlopen(request, timeout=20) as response:
        return json.loads(response.read().decode("utf-8"))


        
def convert_eur_to_dop(amount):
    if amount is None:
        return None

    url = "https://open.er-api.com/v6/latest/EUR"

    request = Request(
        url,
        headers={"User-Agent": "SnapCard/1.0"}
    )

    with urlopen(request, timeout=15) as response:
        data = json.loads(response.read().decode("utf-8"))

    if data.get("result") != "success":
        raise ValueError("No se pudo obtener la tasa de cambio")

    rate = data.get("rates", {}).get("DOP")

    if not rate:
        raise ValueError("No se encontró la tasa EUR a DOP")

    return round(float(amount) * float(rate), 2)
