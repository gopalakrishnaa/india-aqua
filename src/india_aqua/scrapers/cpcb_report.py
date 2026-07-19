"""CPCB 'Polluted River Stretches' report importer.

Unlike the other scrapers in this package, this one doesn't hit a live
telemetry endpoint. CPCB publishes this assessment as a PDF every couple of
years (2018, 2022, ...), covering every state/UT's monitored river stretches
with a real BOD reading and priority class. We download it, extract the
per-state tables, geocode each stretch, and synthesize the metrics CPCB
doesn't report (pH/DO/COD/turbidity/temperature) from the real BOD using a
plausible pollution-correlated model, clearly labelled as such in raw_text.

Given how infrequently the source updates, this is meant to be run by hand
(`india-aqua import-cpcb-report`) when a new edition drops, not on a tight
schedule.
"""

from __future__ import annotations

import json
import logging
import random
import re
from datetime import UTC, datetime
from pathlib import Path

import httpx
from pypdf import PdfReader

from india_aqua.scrapers.base import BaseScraper, ScrapedReading

logger = logging.getLogger(__name__)

REPORT_URL = "https://nmcg.nic.in/pdf/CPCB%20Report%20_PollutedStretches-2022.pdf"
REPORT_LABEL = "CPCB Polluted River Stretches for Restoration of Water Quality - 2022"
# The report presents 2019 & 2021 monitoring data; there's no finer-grained
# date per stretch, so every reading is stamped with the report's publish date.
RECORDED_AT = datetime(2022, 11, 1, tzinfo=UTC)

GEOCODE_CACHE_PATH = Path(__file__).resolve().parents[3] / "data" / "cpcb_geocode_cache.json"

# India's rough bounding box. Coordinates outside this are almost certainly a
# bad geocode (wrong country matched) and get dropped rather than inserted.
INDIA_BBOX = {"lat_min": 6.0, "lat_max": 38.0, "lon_min": 68.0, "lon_max": 98.0}

VALID_PRIORITIES = {"I", "II", "III", "IV", "V"}

STATE_CENTROIDS: dict[str, tuple[float, float]] = {
    "ANDHRA PRADESH": (15.9129, 79.7400), "ARUNACHAL PRADESH": (28.2180, 94.7278),
    "ASSAM": (26.2006, 92.9376), "BIHAR": (25.0961, 85.3131),
    "CHHATTISGARH": (21.2787, 81.8661), "DELHI": (28.7041, 77.1025),
    "GOA": (15.2993, 74.1240), "GUJARAT": (22.2587, 71.1924),
    "HARYANA": (29.0588, 76.0856), "HIMACHAL PRADESH": (31.1048, 77.1734),
    "JAMMU & KASHMIR": (33.7782, 76.5762), "JHARKHAND": (23.6102, 85.2799),
    "KARNATAKA": (15.3173, 75.7139), "KERALA": (10.8505, 76.2711),
    "MADHYA PRADESH": (22.9734, 78.6569), "MAHARASHTRA": (19.7515, 75.7139),
    "MANIPUR": (24.6637, 93.9063), "MEGHALAYA": (25.4670, 91.3662),
    "MIZORAM": (23.1645, 92.9376), "NAGALAND": (26.1584, 94.5624),
    "ODISHA": (20.9517, 85.0985), "PUDUCHERRY": (11.9416, 79.8083),
    "PUNJAB": (31.1471, 75.3412), "RAJASTHAN": (27.0238, 74.2179),
    "SIKKIM": (27.5330, 88.5122), "TAMIL NADU": (11.1271, 78.6569),
    "TELANGANA": (18.1124, 79.0193), "TRIPURA": (23.9408, 91.9882),
    "UTTAR PRADESH": (26.8467, 80.9462), "UTTARAKHAND": (30.0668, 79.0193),
    "WEST BENGAL": (22.9868, 87.8550), "DAMAN AND DIU": (20.3974, 72.8328),
}

STATE_ABBR: dict[str, str] = {
    "ANDHRA PRADESH": "AP", "ARUNACHAL PRADESH": "AR", "ASSAM": "AS", "BIHAR": "BR",
    "CHHATTISGARH": "CG", "DELHI": "DL", "GOA": "GA", "GUJARAT": "GJ", "HARYANA": "HR",
    "HIMACHAL PRADESH": "HP", "JAMMU & KASHMIR": "JK", "JHARKHAND": "JH", "KARNATAKA": "KA",
    "KERALA": "KL", "MADHYA PRADESH": "MP", "MAHARASHTRA": "MH", "MANIPUR": "MN",
    "MEGHALAYA": "ML", "MIZORAM": "MZ", "NAGALAND": "NL", "ODISHA": "OD",
    "PUDUCHERRY": "PY", "PUNJAB": "PB", "RAJASTHAN": "RJ", "SIKKIM": "SK",
    "TAMIL NADU": "TN", "TELANGANA": "TG", "TRIPURA": "TR", "UTTAR PRADESH": "UP",
    "UTTARAKHAND": "UK", "WEST BENGAL": "WB", "DAMAN AND DIU": "DD",
}

_STATE_HEADER_RE = re.compile(r"WATER QUALITY OF RIVERS IN ([A-Z &,]+?)\s*$")
_ROW_START_RE = re.compile(r"^\s*(\d+)\.\s*(.*)$")
_ROW_END_RE = re.compile(r"(\d+(?:\.\d+)?)\s+(I|II|III|IV|V)\s*$")
_PLACE_PREFIX_RE = re.compile(r"^(ALONG|NEAR|UPSTREAM OF|DOWNSTREAM OF|D/S OF|U/S OF)\s+", re.I)


def fetch_pdf_text(url: str = REPORT_URL, *, timeout: float = 60.0) -> str:
    # nmcg.nic.in's TLS chain verifies fine against the OS trust store (curl,
    # browsers) but not against certifi's bundled CA list. NIC-issued certs
    # for .nic.in domains commonly chain through an Indian government root
    # that isn't in the public Mozilla bundle Python ships. This is a
    # known-source, read-only fetch of a public PDF (no secrets in play), so
    # skipping verification here is a scoped, documented trade-off rather
    # than a blanket one.
    resp = httpx.get(
        url,
        headers={"User-Agent": "india-aqua-import/1.0"},
        timeout=timeout,
        follow_redirects=True,
        verify=False,
    )
    resp.raise_for_status()
    body = resp.content
    # NMCG's mirror sometimes wraps the PDF in a stray HTML fragment before
    # the real %PDF header. Strip anything before it.
    idx = body.find(b"%PDF")
    if idx > 0:
        body = body[idx:]
    reader = PdfReader(__import__("io").BytesIO(body))
    return "\n".join(page.extract_text() or "" for page in reader.pages)


def parse_rows(text: str) -> list[dict]:
    """Extract (state, river, location, max_bod, priority) rows from the
    per-state 'Table - N: Number of Polluted River Stretches in <State>'
    sections. Table headers / page-footer lines are skipped; a row's cells
    may wrap across several physical lines, so rows are accumulated until a
    trailing '<BOD> <priority>' is seen."""
    rows: list[dict] = []
    current_state: str | None = None
    buffer: str | None = None
    swapped_warnings: list[str] = []

    def flush():
        nonlocal buffer
        if buffer is None or current_state is None:
            buffer = None
            return
        m = _ROW_END_RE.search(buffer)
        if not m:
            buffer = None
            return
        bod, priority = float(m.group(1)), m.group(2)
        head = buffer[: m.start()].strip()
        parts = head.split(None, 1)
        river = parts[0].strip(" -") if parts else ""
        location = parts[1].strip() if len(parts) > 1 else ""
        if not location and river:
            # River cell wrapped across a line break with no location text
            # captured, or the "river" we grabbed is actually location prose.
            # Best effort: keep the whole head as the location and flag it.
            location = head
            swapped_warnings.append(f"{current_state}: {head!r}")
        if not river or not location:
            # Coincidental "<number> <roman numeral>" match inside ordinary
            # prose (not a real table row). Nothing usable to recover.
            buffer = None
            return
        rows.append({
            "state": current_state,
            "river": river,
            "location": location,
            "max_bod": bod,
            "priority": priority,
        })
        buffer = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            continue

        m = _STATE_HEADER_RE.search(line)
        if m:
            flush()
            current_state = m.group(1).strip().rstrip(",")
            continue

        upper = line.upper()
        if upper.startswith("ANNEXURE"):
            # Per-state tables are done; Annexure IV-VIII re-list the same
            # rows grouped by priority class instead of by state. Same row
            # shape, would otherwise get misattributed to the last state seen.
            flush()
            current_state = None
            continue
        if line.startswith("Page ") or "POLLUTED RIVER STRETCH" in upper or upper.startswith("TABLE -"):
            continue
        if upper.startswith("S NO.") and "RIVER" in upper:
            flush()
            continue

        row_start = _ROW_START_RE.match(line)
        if row_start:
            flush()
            buffer = row_start.group(2)
            if _ROW_END_RE.search(buffer):
                flush()
            continue

        if buffer is not None:
            buffer = f"{buffer} {line}"
            if _ROW_END_RE.search(buffer):
                flush()

    flush()

    if swapped_warnings:
        logger.warning(
            "CPCB parser: %d row(s) had ambiguous river/location split (kept full text as location): %s",
            len(swapped_warnings),
            "; ".join(swapped_warnings[:10]),
        )
    return rows


def _extract_place(location: str, river: str) -> str:
    loc = re.split(r",| TO ", location, maxsplit=1, flags=re.I)[0].strip()
    loc = _PLACE_PREFIX_RE.sub("", loc).strip()
    loc = re.sub(r"\s*\(.*?\)\s*", " ", loc).strip()
    if not loc or loc.upper() == river.upper():
        return ""
    return loc.title()


class GeocodeCache:
    def __init__(self, path: Path = GEOCODE_CACHE_PATH):
        self.path = path
        self._data: dict[str, list[float] | None] = {}
        if path.exists():
            self._data = json.loads(path.read_text())
        self._dirty = False

    def get(self, key: str):
        if key not in self._data:
            return None, False
        v = self._data[key]
        return (tuple(v) if v else None), True

    def set(self, key: str, value: tuple[float, float] | None) -> None:
        self._data[key] = list(value) if value else None
        self._dirty = True

    def save(self) -> None:
        if not self._dirty:
            return
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.path.write_text(json.dumps(self._data, indent=2, sort_keys=True))
        self._dirty = False


def geocode(query: str, cache: GeocodeCache, client: httpx.Client) -> tuple[float, float] | None:
    cached, found = cache.get(query)
    if found:
        return cached
    result = None
    try:
        resp = client.get(
            "https://nominatim.openstreetmap.org/search",
            params={"q": query, "format": "json", "limit": 1, "countrycodes": "in"},
            headers={"User-Agent": "india-aqua-import/1.0 (contact: bhat.gka666@gmail.com)"},
            timeout=15,
        )
        resp.raise_for_status()
        data = resp.json()
        if data:
            result = (float(data[0]["lat"]), float(data[0]["lon"]))
    except Exception as exc:  # noqa: BLE001 - geocoding is best-effort, fall through to state centroid
        logger.warning("Geocode failed for %r: %s", query, exc)
    cache.set(query, result)
    import time

    time.sleep(1.1)  # Nominatim usage policy: max 1 req/sec
    return result


def resolve_coordinates(row: dict, cache: GeocodeCache, client: httpx.Client) -> tuple[float, float]:
    state_title = row["state"].title().replace("And", "and")
    place = _extract_place(row["location"], row["river"])

    if place:
        coord = geocode(f"{place}, {state_title}, India", cache, client)
        if coord:
            return coord

    coord = geocode(f"{row['river']} river, {state_title}, India", cache, client)
    if coord:
        return coord

    return STATE_CENTROIDS.get(row["state"], (22.0, 79.0))  # India's rough centroid, last resort


def derive_synthetic_metrics(bod: float, seed: int) -> dict:
    """CPCB reports only BOD. The rest is a plausible pollution-correlated
    placeholder, not a real reading. Always cited as such in raw_text."""
    rng = random.Random(seed)
    do = max(0.5, min(9.0, 9.0 - bod * 0.22 + rng.uniform(-0.6, 0.6)))
    turbidity = max(3.0, min(300.0, 8.0 + bod * 2.6 + rng.uniform(-8, 8)))
    cod = max(bod * 1.4, bod * rng.uniform(1.6, 2.8) + rng.uniform(0, 4))
    return {
        "ph": round(rng.uniform(6.6, 8.2), 2),
        "dissolved_oxygen_mg_l": round(do, 2),
        "bod_mg_l": round(bod, 2),
        "cod_mg_l": round(cod, 2),
        "turbidity_ntu": round(turbidity, 2),
        "temperature_c": round(rng.uniform(19.0, 31.0), 2),
    }


def is_sane(row: dict, lat: float, lon: float) -> bool:
    return (
        row["priority"] in VALID_PRIORITIES
        and 0 <= row["max_bod"] <= 500
        and INDIA_BBOX["lat_min"] <= lat <= INDIA_BBOX["lat_max"]
        and INDIA_BBOX["lon_min"] <= lon <= INDIA_BBOX["lon_max"]
    )


class CPCBReportScraper(BaseScraper):
    """One-shot importer for the CPCB Polluted River Stretches report.

    Not part of the periodic demo/live scrape rotation. Run explicitly via
    `india-aqua import-cpcb-report` when a new report edition is published.
    """

    name = "cpcb_report"

    async def scrape(self) -> list[ScrapedReading]:
        text = fetch_pdf_text()
        rows = parse_rows(text)
        logger.info("Parsed %d CPCB stretch rows", len(rows))

        cache = GeocodeCache()
        readings: list[ScrapedReading] = []
        state_seq: dict[str, int] = {}
        skipped = 0

        with httpx.Client() as client:
            for i, row in enumerate(rows):
                lat, lon = resolve_coordinates(row, cache, client)
                if not is_sane(row, lat, lon):
                    logger.warning("Dropping implausible row: %s", row)
                    skipped += 1
                    continue

                abbr = STATE_ABBR.get(row["state"], "IN")
                state_seq[abbr] = state_seq.get(abbr, 0) + 1
                cpcb_code = f"CPCB-{abbr}-{state_seq[abbr]:03d}"

                river_title = row["river"].title()
                loc_title = row["location"].title()
                name = f"{river_title} ({loc_title})" if loc_title.upper() != river_title.upper() else f"{river_title} ({row['state'].title()})"

                metrics = derive_synthetic_metrics(row["max_bod"], seed=i)
                raw_text = (
                    f"Source: {REPORT_LABEL}.\n"
                    f"State: {row['state'].title()}\n"
                    f"River: {river_title}\n"
                    f"Stretch/Location: {row['location'].title()}\n"
                    f"CPCB Priority Class: {row['priority']} "
                    f"(based on max BOD observed during 2019 & 2021 monitoring)\n"
                    f"Max BOD observed (real, CPCB-reported): {row['max_bod']} mg/L\n"
                    "NOTE: pH, DO, COD, turbidity and temperature are ESTIMATED "
                    "placeholders derived from the real BOD figure, pending live "
                    "sensor integration for this stretch."
                )

                readings.append(
                    ScrapedReading(
                        station_name=name,
                        location=f"{loc_title}, {row['state'].title()}",
                        source_url=REPORT_URL,
                        raw_text=raw_text,
                        recorded_at=RECORDED_AT,
                        river=river_title,
                        metrics=metrics,
                        cpcb_code=cpcb_code,
                        latitude=lat,
                        longitude=lon,
                    )
                )

        cache.save()
        logger.info("CPCB import: %d readings ready, %d dropped as implausible", len(readings), skipped)
        return readings
