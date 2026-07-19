"""Madhya Pradesh Pollution Control Board river monitoring portal.

Covers Narmada plus its Kshipra and Kanha tributaries. Unlike CPCB's SWAN
network (scrapers/cpcb_realtime.py), this isn't a JSON API: it's a single
kiosk-style HTML page (tpro.telsys.in/tpportal/mppcb_rivers) that
auto-rotates through stations client-side. All station metadata and the
latest reading for every station are embedded directly in that one HTML
response, so one fetch gets everything: no per-station requests needed.

Each station is a `<div class="mySlides" id='{python-dict-literal}'>`
block, HTML-entity-escaped. The dict isn't valid JSON (single-quoted), so
it's parsed with `ast.literal_eval` after unescaping, which is safe here
since it only evaluates literals, not arbitrary code.
"""

from __future__ import annotations

import ast
import html
import logging
import re
from datetime import datetime, timedelta, timezone

import httpx

from india_aqua.scrapers.base import BaseScraper, ScrapedReading

logger = logging.getLogger(__name__)

PORTAL_URL = "https://tpro.telsys.in/tpportal/mppcb_rivers"

# The portal reports "Last Update" as a plain "YYYY-MM-DD HH:MM:SS" string
# with no timezone marker. MPPCB is a Madhya Pradesh state body publishing
# for a domestic audience, so IST is the only reasonable reading; there's
# no way to confirm this from the page itself.
_IST = timezone(timedelta(hours=5, minutes=30))

_SLIDE_RE = re.compile(r'<div class="mySlides" id=\'(.*?)\' value="">', re.DOTALL)
_LAST_UPDATE_RE = re.compile(r"Last Update\s*:\s*</b><b>(.*?)</b>")
_ROW_RE = re.compile(r"<td>([^<]*)</td>\s*<td>\s*<b>\s*([^<]*?)\s*</b>\s*</td>")
_SITE_ID_RE = re.compile(r"site_(\d+)")

# Table label -> our schema's metric field. The portal also reports Colour
# (Hazen-eq.) and TSS, which we don't have columns for; kept in raw_text for
# provenance, not stored structured (same convention as cpcb_realtime.py).
PARAMETER_MAP = {
    "BOD (mg/l)": "bod_mg_l",
    "COD (mg/l)": "cod_mg_l",
    "DO (mg/l)": "dissolved_oxygen_mg_l",
    "pH (pH)": "ph",
    "Temp. (°C)": "temperature_c",
}

# This portal only ever reports these three rivers. Station-level `river`
# metadata is inconsistent (typos, blank, or an unrelated location name), so
# matching against this fixed list is more reliable than trusting it as-is.
_KNOWN_RIVERS = ["Narmada", "Kshipra", "Kanha"]
_RIVER_RE = re.compile("|".join(_KNOWN_RIVERS), re.IGNORECASE)


def _normalize_river(meta: dict) -> str:
    m = _RIVER_RE.search(meta.get("river") or "")
    if m:
        return m.group(0).title()
    m = _RIVER_RE.search(meta.get("name") or "")
    if m:
        return m.group(0).title()
    return "Narmada"


def _extract_metrics(slide_html: str) -> tuple[dict[str, float], list[str]]:
    metrics: dict[str, float] = {}
    extras: list[str] = []
    for label, value in _ROW_RE.findall(slide_html):
        value = value.strip()
        if not value or value == "-":
            continue
        field = PARAMETER_MAP.get(label)
        if field:
            try:
                metrics[field] = float(value)
            except ValueError:
                continue
        else:
            extras.append(f"{label}: {value}")
    return metrics, extras


class MPPCBRiversScraper(BaseScraper):
    """Live MPPCB reader for Narmada, Kshipra, and Kanha. Real values only."""

    name = "mppcb_rivers"
    requires_llm_validation = False  # raw_text is generated from `metrics`, not the other way around

    async def scrape(self) -> list[ScrapedReading]:
        async with httpx.AsyncClient(timeout=30.0) as client:
            resp = await client.get(PORTAL_URL, headers={"User-Agent": "india-aqua/1.0"})
            resp.raise_for_status()
        page = resp.text

        slides = list(re.finditer(r'<div class="mySlides" id=.*?(?=<div class="mySlides" id=|\Z)', page, re.DOTALL))

        out: list[ScrapedReading] = []
        for slide_match in slides:
            slide_html = slide_match.group(0)
            meta_match = _SLIDE_RE.search(slide_html)
            if not meta_match:
                continue
            meta = ast.literal_eval(html.unescape(meta_match.group(1)))

            metrics, extras = _extract_metrics(slide_html)
            if not metrics:
                continue

            lu_match = _LAST_UPDATE_RE.search(slide_html)
            if not lu_match:
                continue
            try:
                recorded_at = datetime.strptime(lu_match.group(1).strip(), "%Y-%m-%d %H:%M:%S").replace(tzinfo=_IST)
            except ValueError:
                logger.warning("Unparseable Last Update %r for %s, skipping", lu_match.group(1), meta.get("name"))
                continue

            site_id_match = _SITE_ID_RE.search(meta.get("gov_page_url", ""))
            code = f"MPPCB-{site_id_match.group(1)}" if site_id_match else None

            name = meta.get("name") or meta.get("station") or "Unknown station"
            city = meta.get("city", "")

            raw_lines = [
                f"Source: Madhya Pradesh Pollution Control Board river monitoring portal, station {code}.",
                f"Station: {name}",
                f"City: {city}",
                f"Regional office: {meta.get('ro', '')}",
                f"Timestamp: {recorded_at.isoformat()}",
            ]
            for field, value in metrics.items():
                raw_lines.append(f"{field}: {value}")
            if extras:
                raw_lines.append("Additional parameters (not stored, reference only): " + "; ".join(extras))

            # Station names already name their city almost every time
            # ("River Narmada at ... Amarkantak", city="Amarkantak"), so
            # appending it again would read as a stutter.
            location = name if not city or city.lower() in name.lower() else f"{name}, {city}"

            out.append(
                ScrapedReading(
                    station_name=f"{code} ({name})" if code else name,
                    location=location,
                    source_url=meta.get("gov_page_url") or PORTAL_URL,
                    raw_text="\n".join(raw_lines),
                    recorded_at=recorded_at,
                    river=_normalize_river(meta),
                    metrics=metrics,
                    cpcb_code=code,
                    latitude=meta.get("latitude"),
                    longitude=meta.get("longitude"),
                )
            )

        logger.info("MPPCB rivers: %d stations with readings out of %d known", len(out), len(slides))
        return out
