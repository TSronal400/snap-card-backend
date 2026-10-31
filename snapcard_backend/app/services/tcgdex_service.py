
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

