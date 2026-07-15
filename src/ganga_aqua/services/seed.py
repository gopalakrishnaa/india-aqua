"""Seed realistic Ganga sample data."""

from __future__ import annotations

import logging
import random
from datetime import UTC, datetime, timedelta

from sqlalchemy.orm import Session

from ganga_aqua.agents.analyzer import classify_wqi, compute_wqi
from ganga_aqua.config import get_settings
from ganga_aqua.db.models import MonitoringStation, SaasClient, SaasTier, WaterQualityReading
from ganga_aqua.scrapers.ganga_sources import DEMO_STATIONS
from ganga_aqua.services.auth import create_client, generate_api_key

logger = logging.getLogger(__name__)

SEED_HISTORY_DAYS = 30


def seed_stations_and_readings(db: Session) -> tuple[int, int]:
    stations_created = 0
    readings_created = 0
    now = datetime.now(UTC)

    for station_data in DEMO_STATIONS:
        station = db.query(MonitoringStation).filter(MonitoringStation.cpcb_code == station_data["cpcb_code"]).first()
        if not station:
            station = MonitoringStation(
                name=station_data["name"],
                river=station_data.get("river", "Ganga"),
                location=station_data["location"],
                cpcb_code=station_data["cpcb_code"],
                latitude=station_data["latitude"],
                longitude=station_data["longitude"],
            )
            db.add(station)
            db.flush()
            stations_created += 1

        existing = db.query(WaterQualityReading).filter(WaterQualityReading.station_id == station.id).count()
        if existing >= SEED_HISTORY_DAYS:
            continue

        for day_offset in range(SEED_HISTORY_DAYS):
            recorded_at = now - timedelta(days=day_offset, hours=random.randint(0, 12))
            metrics = {
                "ph": round(random.uniform(6.8, 8.5), 2),
                "dissolved_oxygen_mg_l": round(random.uniform(2.0, 9.5), 2),
                "bod_mg_l": round(random.uniform(1.5, 12.0), 2),
                "cod_mg_l": round(random.uniform(5.0, 40.0), 2),
                "turbidity_ntu": round(random.uniform(10.0, 120.0), 2),
                "temperature_c": round(random.uniform(18.0, 32.0), 2),
            }
            wqi = compute_wqi(metrics)
            raw_text = (
                f"Station: {station_data['name']}\n"
                f"pH: {metrics['ph']}\n"
                f"DO: {metrics['dissolved_oxygen_mg_l']} mg/L\n"
            )
            reading = WaterQualityReading(
                station_id=station.id,
                ph=metrics["ph"],
                dissolved_oxygen_mg_l=metrics["dissolved_oxygen_mg_l"],
                bod_mg_l=metrics["bod_mg_l"],
                cod_mg_l=metrics["cod_mg_l"],
                turbidity_ntu=metrics["turbidity_ntu"],
                temperature_c=metrics["temperature_c"],
                wqi=wqi,
                quality_class=classify_wqi(wqi) if wqi is not None else None,
                recorded_at=recorded_at,
                source_url=station_data["source_url"],
                raw_text=raw_text,
            )
            db.add(reading)
            readings_created += 1

    db.commit()
    return stations_created, readings_created


def seed_bootstrap_client(db: Session) -> str | None:
    settings = get_settings()
    raw_key = settings.bootstrap_api_key or generate_api_key()
    existing = db.query(SaasClient).filter(SaasClient.name == "bootstrap-admin").first()
    if existing:
        return None
    create_client(db, name="bootstrap-admin", raw_key=raw_key, tier=SaasTier.ENTERPRISE, rate_limit="1000/minute")
    return raw_key


def run_seed(db: Session) -> dict:
    stations, readings = seed_stations_and_readings(db)
    api_key = seed_bootstrap_client(db)
    result = {"stations_created": stations, "readings_created": readings}
    if api_key:
        result["bootstrap_api_key"] = api_key
    logger.info("Seed complete: %s", result)
    return result
