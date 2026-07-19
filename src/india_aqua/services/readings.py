"""Readings query service."""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

from sqlalchemy import func
from sqlalchemy.orm import Session, joinedload

from india_aqua.db.models import MonitoringStation, WaterQualityReading

EXPECTED_METRICS = [
    "ph",
    "dissolved_oxygen_mg_l",
    "bod_mg_l",
    "cod_mg_l",
    "turbidity_ntu",
    "temperature_c",
]

METRIC_LABELS = {
    "ph": "pH",
    "dissolved_oxygen_mg_l": "Dissolved Oxygen (mg/L)",
    "bod_mg_l": "BOD (mg/L)",
    "cod_mg_l": "COD (mg/L)",
    "turbidity_ntu": "Turbidity (NTU)",
    "temperature_c": "Temperature (°C)",
}


def list_stations(db: Session, river: str | None = None) -> list[MonitoringStation]:
    q = db.query(MonitoringStation)
    if river:
        q = q.filter(MonitoringStation.river == river)
    return q.order_by(MonitoringStation.name).all()


def list_rivers(db: Session) -> list[str]:
    rows = (
        db.query(MonitoringStation.river)
        .distinct()
        .order_by(MonitoringStation.river)
        .all()
    )
    return [r[0] for r in rows if r[0]]


def get_latest_readings(db: Session, station_id: int | None = None) -> list[WaterQualityReading]:
    subq = (
        db.query(
            WaterQualityReading.station_id,
            func.max(WaterQualityReading.recorded_at).label("max_recorded"),
        )
        .group_by(WaterQualityReading.station_id)
        .subquery()
    )
    q = (
        db.query(WaterQualityReading)
        .options(joinedload(WaterQualityReading.station))
        .join(
            subq,
            (WaterQualityReading.station_id == subq.c.station_id)
            & (WaterQualityReading.recorded_at == subq.c.max_recorded),
        )
    )
    if station_id:
        q = q.filter(WaterQualityReading.station_id == station_id)
    return q.order_by(WaterQualityReading.station_id).all()


def get_readings_history(
    db: Session,
    station_id: int | None = None,
    days: int = 30,
    limit: int = 500,
) -> list[WaterQualityReading]:
    since = datetime.now(UTC) - timedelta(days=days)
    q = (
        db.query(WaterQualityReading)
        .options(joinedload(WaterQualityReading.station))
        .filter(WaterQualityReading.recorded_at >= since)
    )
    if station_id:
        q = q.filter(WaterQualityReading.station_id == station_id)
    return q.order_by(WaterQualityReading.recorded_at.desc()).limit(limit).all()


def get_deficiency_report(db: Session) -> list[dict]:
    """Stations missing recent readings or with null critical metrics."""
    report: list[dict] = []
    stations = list_stations(db)
    latest = {r.station_id: r for r in get_latest_readings(db)}
    cutoff = (datetime.now(UTC) - timedelta(days=7)).replace(tzinfo=None)

    for station in stations:
        reading = latest.get(station.id)
        issues: list[str] = []
        if not reading:
            issues.append("No readings on record")
        elif reading.recorded_at.replace(tzinfo=None) < cutoff:
            issues.append(f"Stale data: last reading {reading.recorded_at.date()}")
        elif reading:
            for metric in EXPECTED_METRICS:
                if getattr(reading, metric) is None:
                    issues.append(f"Missing {METRIC_LABELS[metric]}")

        if issues:
            report.append(
                {
                    "station_id": station.id,
                    "station_name": station.name,
                    "location": station.location,
                    "issues": issues,
                    "last_reading_at": reading.recorded_at.isoformat() if reading else None,
                }
            )
    return report
