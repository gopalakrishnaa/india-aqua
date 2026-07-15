"""Scrape pipeline tests — dedup, river attribution, analyze wiring."""

from datetime import UTC, datetime
from unittest.mock import MagicMock

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from ganga_aqua.agents.analyzer import AnalysisResult
from ganga_aqua.agents.validator import ValidationResult
from ganga_aqua.db.base import Base
from ganga_aqua.db.models import MonitoringStation, WaterQualityReading
from ganga_aqua.scrapers.base import ScrapedReading
from ganga_aqua.services.scrape_pipeline import process_reading


@pytest.fixture()
def db():
    engine = create_engine(
        "sqlite+pysqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    session = sessionmaker(bind=engine)()
    try:
        yield session
    finally:
        session.close()


def _scraped() -> ScrapedReading:
    return ScrapedReading(
        station_name="Delhi (ITO Bridge)",
        location="Delhi",
        source_url="https://cpcb.nic.in/water-quality/",
        raw_text="pH: 7.2",
        recorded_at=datetime(2026, 7, 15, 8, 0, tzinfo=UTC),
        river="Yamuna",
        metrics={"ph": 7.2, "dissolved_oxygen_mg_l": 6.0, "bod_mg_l": 2.0, "turbidity_ntu": 8.0},
        cpcb_code="YMN-DEL-001",
    )


def _validator(valid: bool = True):
    v = MagicMock()
    v.validate.return_value = ValidationResult(valid=valid, reason="" if valid else "mismatch")
    return v


def _analyzer():
    a = MagicMock()
    a.analyze.return_value = AnalysisResult(wqi=72.0, quality_class="Moderate", note="ok")
    return a


def test_stores_reading_with_river_and_wqi(db):
    status = process_reading(db, _scraped(), _validator(), _analyzer())
    assert status == "stored"
    station = db.query(MonitoringStation).one()
    assert station.river == "Yamuna"
    reading = db.query(WaterQualityReading).one()
    assert reading.wqi == 72.0
    assert reading.quality_class == "Moderate"


def test_duplicate_reading_skipped(db):
    assert process_reading(db, _scraped(), _validator(), _analyzer()) == "stored"
    assert process_reading(db, _scraped(), _validator(), _analyzer()) == "duplicate"
    assert db.query(WaterQualityReading).count() == 1


def test_rejected_reading_not_stored(db):
    status = process_reading(db, _scraped(), _validator(valid=False), _analyzer())
    assert status == "rejected"
    assert db.query(WaterQualityReading).count() == 0
