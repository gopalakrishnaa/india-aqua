"""CPCB Real-Time Water Quality Monitoring System (RTWQMS / SWAN network).

Unlike scrapers/cpcb_report.py (a biennial PDF, imported by hand), this hits
a genuinely live public feed: rtwqmsdb1.cpcb.gov.in publishes station
metadata and per-parameter readings as static JSON, refreshed roughly every
30 minutes from telemetry stations across the Ganga basin. No login, no
scraping of rendered HTML. These are the same JSON endpoints the CPCB
dashboard's own frontend calls.

Meant to run on a schedule, not by hand. See .github/workflows/cron-scrape.yml,
which hits GET /api/v1/internal/cron/scrape every 30min (moved off Vercel's
native cron, since the Hobby plan caps that at once/day and the source itself
refreshes roughly every 30min). This is the one CPCB source where that cadence
actually matters.
"""

from __future__ import annotations

import logging
import re
from collections import defaultdict
from datetime import datetime

import httpx

from india_aqua.scrapers.base import BaseScraper, ScrapedReading

logger = logging.getLogger(__name__)

BASE_URL = "https://rtwqmsdb1.cpcb.gov.in"
STATIONS_URL = f"{BASE_URL}/data/internet/stations/stations.json"
READINGS_URL = f"{BASE_URL}/data/internet/layers/10/index.json"

# rtwqmsdb1.cpcb.gov.in's TLS chain has the same NIC-root issue as
# nmcg.nic.in (see scrapers/cpcb_report.py). Verified fine against the OS
# trust store, not against certifi's bundle. Public read-only JSON, no
# secrets in play.
_VERIFY_TLS = False

# CPCB's `stationparameter_longname` -> our schema's metric field. CPCB also
# reports Nitrate/Conductivity/TOC/Chloride/River Stage/Depth, which we don't
# have columns for, kept in raw_text for provenance, not stored structured.
PARAMETER_MAP = {
    "pH": "ph",
    "Water Temperature": "temperature_c",
    "Biochemical Oxygen Demand": "bod_mg_l",
    "Chemical Oxygen Demand": "cod_mg_l",
    "Oxygen, dissolved": "dissolved_oxygen_mg_l",
    "Water Turbidity": "turbidity_ntu",
}

# SWAN is CPCB's Ganga-basin telemetry network; station names name the exact
# river only inconsistently ("River Ganga at Chausa" vs. just "Sahebganj").
# Match a known tributary if named, else default to Ganga.
_KNOWN_RIVERS = [
    "Ganga", "Yamuna", "Ghagra", "Punpun", "Burhi Gandak", "Kosi", "Son",
    "Gandak", "Damodar", "Hindon", "Ramganga",
]
_RIVER_RE = re.compile("|".join(re.escape(r) for r in _KNOWN_RIVERS), re.IGNORECASE)


def _extract_river(station_name: str) -> str:
    m = _RIVER_RE.search(station_name)
    return m.group(0).title() if m else "Ganga"


def _clean_name(raw: str) -> str:
    # "BH72_River Ganga at Chausa, U/s of Buxar\xa0" -> "River Ganga at Chausa, U/s of Buxar"
    name = raw.replace("\xa0", " ").strip()
    name = re.sub(r"^[A-Z]{2}\d+_", "", name)
    return re.sub(r"\s+", " ", name).strip().rstrip(",.")


class CPCBRealtimeScraper(BaseScraper):
    """Live SWAN network reader. Real values, no synthetic placeholders."""

    name = "cpcb_realtime"
    requires_llm_validation = False  # raw_text is generated from `metrics`, not the other way around

    async def scrape(self) -> list[ScrapedReading]:
        async with httpx.AsyncClient(verify=_VERIFY_TLS, timeout=30.0) as client:
            stations_resp = await client.get(STATIONS_URL, headers={"User-Agent": "india-aqua/1.0"})
            stations_resp.raise_for_status()
            readings_resp = await client.get(READINGS_URL, headers={"User-Agent": "india-aqua/1.0"})
            readings_resp.raise_for_status()

        stations_by_id = {s["station_id"]: s for s in stations_resp.json()}

        by_station: dict[str, list[dict]] = defaultdict(list)
        for row in readings_resp.json():
            by_station[row["station_id"]].append(row)

        out: list[ScrapedReading] = []
        for station_id, rows in by_station.items():
            station = stations_by_id.get(station_id)
            if not station:
                logger.warning("Reading for unknown station_id %s, skipping", station_id)
                continue

            metrics: dict[str, float] = {}
            extras: list[str] = []
            latest_ts: datetime | None = None
            for row in rows:
                param = row.get("stationparameter_longname")
                value = row.get("ts_value")
                if value is None:
                    continue
                ts = datetime.fromisoformat(row["timestamp"].replace("Z", "+00:00"))
                if latest_ts is None or ts > latest_ts:
                    latest_ts = ts
                field = PARAMETER_MAP.get(param)
                if field:
                    metrics[field] = float(value)
                else:
                    unit = row.get("ts_unitsymbol", "")
                    extras.append(f"{param}: {value} {unit}".strip())

            if not metrics or latest_ts is None:
                continue

            name = _clean_name(station["station_name"])
            river = _extract_river(name)
            lat = float(station["station_latitude"])
            lon = float(station["station_longitude"])

            raw_lines = [
                f"Source: CPCB Real-Time Water Quality Monitoring System (SWAN network), "
                f"station {station['station_no']}.",
                f"Station: {name}",
                f"State: {station.get('territory_name', '')}",
                f"Timestamp: {latest_ts.isoformat()}",
            ]
            for field, value in metrics.items():
                raw_lines.append(f"{field}: {value}")
            if extras:
                raw_lines.append("Additional parameters (not stored, reference only): " + "; ".join(extras))

            out.append(
                ScrapedReading(
                    station_name=f"{station['station_no']} ({name})",
                    location=f"{name}, {station.get('territory_name', '')}",
                    source_url=BASE_URL,
                    raw_text="\n".join(raw_lines),
                    recorded_at=latest_ts,
                    river=river,
                    metrics=metrics,
                    cpcb_code=station["station_no"],
                    latitude=lat,
                    longitude=lon,
                )
            )

        logger.info("CPCB realtime: %d stations with readings out of %d known", len(out), len(stations_by_id))
        return out
