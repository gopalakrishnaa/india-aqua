"""Scrape → validate → persist pipeline."""

from __future__ import annotations

import json
import logging

from sqlalchemy.orm import Session

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
            location=scraped.location,
            cpcb_code=scraped.cpcb_code,
            latitude=scraped.latitude,
            longitude=scraped.longitude,
        )
        db.add(station)
        db.flush()
    return station


def process_reading(db: Session, scraped: ScrapedReading, validator: LLMValidator) -> bool:
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
        return False

    station = _get_or_create_station(db, scraped)
    reading = WaterQualityReading(
        station_id=station.id,
        ph=scraped.metrics.get("ph"),
        dissolved_oxygen_mg_l=scraped.metrics.get("dissolved_oxygen_mg_l"),
        bod_mg_l=scraped.metrics.get("bod_mg_l"),
        cod_mg_l=scraped.metrics.get("cod_mg_l"),
        turbidity_ntu=scraped.metrics.get("turbidity_ntu"),
        temperature_c=scraped.metrics.get("temperature_c"),
        recorded_at=scraped.recorded_at,
        source_url=scraped.source_url,
        raw_text=scraped.raw_text,
    )
    db.add(reading)
    db.commit()
    logger.info("Stored validated reading for %s", scraped.station_name)
    return True


async def run_scrape_pipeline(db: Session, use_playwright: bool = True) -> dict[str, int]:
    scraper = PlaywrightScraper() if use_playwright else __import__(
        "ganga_aqua.scrapers.ganga_sources", fromlist=["DemoScraper"]
    ).DemoScraper()
    validator = LLMValidator()
    scraped_list = await scraper.scrape()

    stored = 0
    rejected = 0
    for scraped in scraped_list:
        try:
            if process_reading(db, scraped, validator):
                stored += 1
            else:
                rejected += 1
        except Exception as exc:
            logger.exception("Pipeline error for %s: %s", scraped.station_name, exc)
            rejected += 1

    return {"scraped": len(scraped_list), "stored": stored, "rejected": rejected}
