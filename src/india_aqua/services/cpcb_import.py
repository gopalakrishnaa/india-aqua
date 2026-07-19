"""Import pipeline for the CPCB Polluted River Stretches report.

Deliberately skips the LLM hallucination validator used by the live scrape
pipeline (services/scrape_pipeline.py). That agent's job is to catch an LLM
fabricating numbers from messy scraped page text. Here the numbers come from
a deterministic table parse of an official PDF, so there's nothing for it to
validate; the sanity gate in scrapers/cpcb_report.py (BOD range, priority
enum, India bounding box) is the equivalent guard for this source.
"""

from __future__ import annotations

import logging

from sqlalchemy.orm import Session

from india_aqua.agents.analyzer import WQIAnalyzer
from india_aqua.db.models import WaterQualityReading
from india_aqua.scrapers.cpcb_report import CPCBReportScraper
from india_aqua.services.scrape_pipeline import _get_or_create_station, _is_duplicate

logger = logging.getLogger(__name__)


async def run_cpcb_import(db: Session, dry_run: bool = False) -> dict[str, int]:
    scraper = CPCBReportScraper()
    analyzer = WQIAnalyzer()
    scraped_list = await scraper.scrape()

    counts = {"scraped": len(scraped_list), "stored": 0, "duplicate": 0, "error": 0}

    for scraped in scraped_list:
        try:
            if dry_run:
                counts["stored"] += 1
                continue

            station = _get_or_create_station(db, scraped)

            if _is_duplicate(db, station.id, scraped):
                db.commit()
                counts["duplicate"] += 1
                continue

            analysis = analyzer.analyze(scraped.metrics)
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
            counts["stored"] += 1
        except Exception:
            db.rollback()
            logger.exception("CPCB import failed for %s", scraped.station_name)
            counts["error"] += 1

    return counts
