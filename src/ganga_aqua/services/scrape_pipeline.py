"""Multi-agent scrape pipeline.

Flow per reading:
  1. scrape        — river scrapers produce ScrapedReading
  2. verify        — LLMValidator (temperature=0) rejects hallucinated/mismatched values
  3. analyze       — WQIAnalyzer computes Water Quality Index + class
  4. dedup         — skip readings already stored for the same station + timestamp
  5. push          — persist validated, analyzed, unique reading
"""

from __future__ import annotations

import json
import logging

from sqlalchemy.orm import Session

from ganga_aqua.agents.analyzer import WQIAnalyzer
from ganga_aqua.agents.validator import LLMValidator
from ganga_aqua.db.models import MonitoringStation, ValidationLog, WaterQualityReading
from ganga_aqua.scrapers.base import ScrapedReading
from ganga_aqua.scrapers.ganga_sources import PlaywrightScraper

logger = logging.getLogger(__name__)


def _get_or_create_station(db: Session, scraped: ScrapedReading) -> MonitoringStation:
    station = None
    if scraped.cpcb_code:
        station = db.query(MonitoringStation).filter(MonitoringStation.cpcb_code == scraped.cpcb_code).first()
    if not station:
        station = (
            db.query(MonitoringStation)
            .filter(MonitoringStation.name == scraped.station_name)
            .first()
        )
    if not station:
        station = MonitoringStation(
            name=scraped.station_name,
            river=scraped.river,
            location=scraped.location,
            cpcb_code=scraped.cpcb_code,
            latitude=scraped.latitude,
            longitude=scraped.longitude,
        )
        db.add(station)
        db.flush()
    elif station.river != scraped.river and scraped.river:
        station.river = scraped.river
    return station


def _is_duplicate(db: Session, station_id: int, scraped: ScrapedReading) -> bool:
    return (
        db.query(WaterQualityReading)
        .filter(
            WaterQualityReading.station_id == station_id,
            WaterQualityReading.recorded_at == scraped.recorded_at,
        )
        .first()
        is not None
    )


def process_reading(
    db: Session,
    scraped: ScrapedReading,
    validator: LLMValidator,
    analyzer: WQIAnalyzer,
) -> str:
    """Returns one of: "stored", "rejected", "duplicate"."""
    # 2. verify (hallucination / mismatch check, temperature=0)
    result = validator.validate(scraped.raw_text, scraped.metrics)
    if not result.valid:
        db.add(
            ValidationLog(
                raw_text=scraped.raw_text,
                extracted_json=json.dumps(scraped.metrics),
                reason=result.reason,
                source_url=scraped.source_url,
            )
        )
        db.commit()
        logger.info("Validation rejected for %s: %s", scraped.station_name, result.reason)
        return "rejected"

    station = _get_or_create_station(db, scraped)

    # 4. dedup — skip if we already have this station+timestamp
    if _is_duplicate(db, station.id, scraped):
        db.commit()  # persist any station river update
        logger.info("Duplicate reading skipped for %s at %s", scraped.station_name, scraped.recorded_at)
        return "duplicate"

    # 3. analyze — Water Quality Index + class
    analysis = analyzer.analyze(scraped.metrics)

    # 5. push
    reading = WaterQualityReading(
        station_id=station.id,
        ph=scraped.metrics.get("ph"),
        dissolved_oxygen_mg_l=scraped.metrics.get("dissolved_oxygen_mg_l"),
        bod_mg_l=scraped.metrics.get("bod_mg_l"),
        cod_mg_l=scraped.metrics.get("cod_mg_l"),
        turbidity_ntu=scraped.metrics.get("turbidity_ntu"),
        temperature_c=scraped.metrics.get("temperature_c"),
        wqi=analysis.wqi,
        quality_class=analysis.quality_class,
        recorded_at=scraped.recorded_at,
        source_url=scraped.source_url,
        raw_text=scraped.raw_text,
    )
    db.add(reading)
    db.commit()
    logger.info(
        "Stored reading for %s (%s) — WQI %.1f %s",
        scraped.station_name,
        scraped.river,
        analysis.wqi,
        analysis.quality_class,
    )
    return "stored"


async def run_scrape_pipeline(db: Session, use_playwright: bool = True) -> dict[str, int]:
    scraper = PlaywrightScraper() if use_playwright else __import__(
        "ganga_aqua.scrapers.ganga_sources", fromlist=["DemoScraper"]
    ).DemoScraper()
    validator = LLMValidator()
    analyzer = WQIAnalyzer()
    scraped_list = await scraper.scrape()

    counts = {"scraped": len(scraped_list), "stored": 0, "rejected": 0, "duplicate": 0}
    for scraped in scraped_list:
        try:
            status = process_reading(db, scraped, validator, analyzer)
            counts[status] += 1
        except Exception as exc:
            logger.exception("Pipeline error for %s: %s", scraped.station_name, exc)
            counts["rejected"] += 1

    return counts
