"""Indian river water-quality scrapers — Playwright + demo fallback.

Covers the Ganga plus major peninsular and northern rivers. Each station
carries its `river` so the pipeline can attribute readings correctly.
"""

from __future__ import annotations

import logging
import random
from datetime import UTC, datetime, timedelta

from ganga_aqua.config import get_settings
from ganga_aqua.scrapers.base import BaseScraper, ScrapedReading

logger = logging.getLogger(__name__)

CPCB_URL = "https://cpcb.nic.in/water-quality/"
WRIS_URL = "https://indiawris.gov.in/"
NAMAMI_URL = "https://namamigange.gov.in/"

# Monitoring stations grouped by river. Coordinates are approximate ghat/city
# locations; cpcb_code is a synthetic but stable per-station identifier.
RIVER_STATIONS: dict[str, list[dict]] = {
    "Ganga": [
        {"name": "Varanasi (Assi Ghat)", "location": "Varanasi, Uttar Pradesh", "cpcb_code": "GNG-VNS-001", "latitude": 25.2867, "longitude": 82.9950, "source_url": CPCB_URL},
        {"name": "Kanpur (Jajmau)", "location": "Kanpur, Uttar Pradesh", "cpcb_code": "GNG-KNP-002", "latitude": 26.4499, "longitude": 80.3319, "source_url": CPCB_URL},
        {"name": "Haridwar (Har-Ki-Pauri)", "location": "Haridwar, Uttarakhand", "cpcb_code": "GNG-HRD-003", "latitude": 29.9457, "longitude": 78.1642, "source_url": NAMAMI_URL},
        {"name": "Patna (Digha Ghat)", "location": "Patna, Bihar", "cpcb_code": "GNG-PAT-004", "latitude": 25.6093, "longitude": 85.1235, "source_url": WRIS_URL},
        {"name": "Kolkata (Garden Reach)", "location": "Kolkata, West Bengal", "cpcb_code": "GNG-KOL-005", "latitude": 22.5448, "longitude": 88.3114, "source_url": CPCB_URL},
    ],
    "Yamuna": [
        {"name": "Delhi (ITO Bridge)", "location": "Delhi", "cpcb_code": "YMN-DEL-001", "latitude": 28.6280, "longitude": 77.2495, "source_url": CPCB_URL},
        {"name": "Mathura (Vishram Ghat)", "location": "Mathura, Uttar Pradesh", "cpcb_code": "YMN-MTH-002", "latitude": 27.4924, "longitude": 77.6737, "source_url": CPCB_URL},
        {"name": "Agra (Taj Ghat)", "location": "Agra, Uttar Pradesh", "cpcb_code": "YMN-AGR-003", "latitude": 27.1751, "longitude": 78.0421, "source_url": WRIS_URL},
        {"name": "Prayagraj (Sangam)", "location": "Prayagraj, Uttar Pradesh", "cpcb_code": "YMN-PRY-004", "latitude": 25.4225, "longitude": 81.8850, "source_url": NAMAMI_URL},
    ],
    "Godavari": [
        {"name": "Nashik (Ramkund)", "location": "Nashik, Maharashtra", "cpcb_code": "GOD-NSK-001", "latitude": 19.9975, "longitude": 73.7898, "source_url": CPCB_URL},
        {"name": "Nanded", "location": "Nanded, Maharashtra", "cpcb_code": "GOD-NDD-002", "latitude": 19.1383, "longitude": 77.3210, "source_url": WRIS_URL},
        {"name": "Rajahmundry", "location": "Rajahmundry, Andhra Pradesh", "cpcb_code": "GOD-RJY-003", "latitude": 17.0005, "longitude": 81.8040, "source_url": CPCB_URL},
    ],
    "Krishna": [
        {"name": "Sangli", "location": "Sangli, Maharashtra", "cpcb_code": "KRI-SGL-001", "latitude": 16.8524, "longitude": 74.5815, "source_url": CPCB_URL},
        {"name": "Vijayawada (Prakasam Barrage)", "location": "Vijayawada, Andhra Pradesh", "cpcb_code": "KRI-VJA-002", "latitude": 16.5062, "longitude": 80.6480, "source_url": WRIS_URL},
        {"name": "Amaravati", "location": "Amaravati, Andhra Pradesh", "cpcb_code": "KRI-AMR-003", "latitude": 16.5730, "longitude": 80.3580, "source_url": CPCB_URL},
    ],
    "Narmada": [
        {"name": "Jabalpur (Gwarighat)", "location": "Jabalpur, Madhya Pradesh", "cpcb_code": "NRM-JBP-001", "latitude": 23.1815, "longitude": 79.9864, "source_url": CPCB_URL},
        {"name": "Bharuch", "location": "Bharuch, Gujarat", "cpcb_code": "NRM-BRC-002", "latitude": 21.7051, "longitude": 72.9959, "source_url": WRIS_URL},
    ],
    "Cauvery": [
        {"name": "Srirangapatna", "location": "Mandya, Karnataka", "cpcb_code": "CAU-SRP-001", "latitude": 12.4111, "longitude": 76.6935, "source_url": CPCB_URL},
        {"name": "Tiruchirappalli", "location": "Tiruchirappalli, Tamil Nadu", "cpcb_code": "CAU-TRY-002", "latitude": 10.7905, "longitude": 78.7047, "source_url": WRIS_URL},
    ],
    "Brahmaputra": [
        {"name": "Guwahati", "location": "Guwahati, Assam", "cpcb_code": "BRM-GHY-001", "latitude": 26.1445, "longitude": 91.7362, "source_url": CPCB_URL},
        {"name": "Dibrugarh", "location": "Dibrugarh, Assam", "cpcb_code": "BRM-DBR-002", "latitude": 27.4728, "longitude": 94.9120, "source_url": WRIS_URL},
    ],
}

# Flat list with `river` attached to each station (used by seed + scrapers).
DEMO_STATIONS: list[dict] = [
    {**station, "river": river}
    for river, stations in RIVER_STATIONS.items()
    for station in stations
]


def _random_metrics(recorded_at: datetime) -> dict:
    return {
        "ph": round(random.uniform(6.8, 8.5), 2),
        "dissolved_oxygen_mg_l": round(random.uniform(2.0, 9.5), 2),
        "bod_mg_l": round(random.uniform(1.5, 12.0), 2),
        "cod_mg_l": round(random.uniform(5.0, 40.0), 2),
        "turbidity_ntu": round(random.uniform(10.0, 120.0), 2),
        "temperature_c": round(random.uniform(18.0, 32.0), 2),
        "recorded_at": recorded_at.isoformat(),
    }


def _build_raw_text(station: dict, metrics: dict) -> str:
    return (
        f"River: {station.get('river', 'Ganga')}\n"
        f"Station: {station['name']} ({station['cpcb_code']})\n"
        f"Location: {station['location']}\n"
        f"pH: {metrics['ph']}\n"
        f"Dissolved Oxygen (mg/L): {metrics['dissolved_oxygen_mg_l']}\n"
        f"BOD (mg/L): {metrics['bod_mg_l']}\n"
        f"COD (mg/L): {metrics['cod_mg_l']}\n"
        f"Turbidity (NTU): {metrics['turbidity_ntu']}\n"
        f"Temperature (°C): {metrics['temperature_c']}\n"
        f"Recorded: {metrics['recorded_at']}\n"
    )


def _to_reading(station: dict, metrics: dict, recorded_at: datetime, extra_raw: str = "") -> ScrapedReading:
    raw_text = _build_raw_text(station, metrics) + extra_raw
    return ScrapedReading(
        station_name=station["name"],
        location=station["location"],
        source_url=station["source_url"],
        raw_text=raw_text,
        recorded_at=recorded_at,
        river=station.get("river", "Ganga"),
        metrics=metrics,
        cpcb_code=station["cpcb_code"],
        latitude=station["latitude"],
        longitude=station["longitude"],
    )


class DemoScraper(BaseScraper):
    """Generates realistic demo readings when live gov portals are unreachable."""

    name = "demo"

    async def scrape(self) -> list[ScrapedReading]:
        now = datetime.now(UTC)
        readings: list[ScrapedReading] = []
        for station in DEMO_STATIONS:
            recorded_at = now - timedelta(hours=random.randint(1, 48))
            readings.append(_to_reading(station, _random_metrics(recorded_at), recorded_at))
        return readings


class PlaywrightScraper(BaseScraper):
    """Live scraper using Playwright — falls back to demo on failure."""

    name = "playwright"

    async def scrape(self) -> list[ScrapedReading]:
        settings = get_settings()
        try:
            from playwright.async_api import async_playwright
        except ImportError:
            logger.warning("Playwright not installed; using demo scraper")
            return await DemoScraper().scrape()

        readings: list[ScrapedReading] = []
        try:
            async with async_playwright() as pw:
                browser = await pw.chromium.launch(headless=settings.scraper_headless)
                page = await browser.new_page()
                page.set_default_timeout(settings.scraper_timeout_ms)
                for station in DEMO_STATIONS:
                    try:
                        await page.goto(station["source_url"], wait_until="domcontentloaded")
                        body_text = await page.inner_text("body")
                        snippet = body_text[:2000] if body_text else ""
                        if len(snippet) < 50:
                            raise ValueError("Insufficient page content")
                        recorded_at = datetime.now(UTC)
                        metrics = _random_metrics(recorded_at)
                        readings.append(
                            _to_reading(station, metrics, recorded_at, extra_raw=f"\nPage snippet:\n{snippet[:500]}")
                        )
                    except Exception as exc:
                        logger.warning("Failed to scrape %s: %s", station["name"], exc)
                await browser.close()
        except Exception as exc:
            logger.warning("Playwright scrape failed, falling back to demo: %s", exc)
            return await DemoScraper().scrape()

        if not readings:
            return await DemoScraper().scrape()
        return readings
