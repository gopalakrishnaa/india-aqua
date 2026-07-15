"""Pydantic response/request schemas."""

from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, ConfigDict


class StationOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    river: str
    location: str
    latitude: float | None
    longitude: float | None
    cpcb_code: str | None


class ReadingOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    station_id: int
    station_name: str | None = None
    ph: float | None
    dissolved_oxygen_mg_l: float | None
    bod_mg_l: float | None
    cod_mg_l: float | None
    turbidity_ntu: float | None
    temperature_c: float | None
    recorded_at: datetime
    source_url: str


class DeficiencyOut(BaseModel):
    station_id: int
    station_name: str
    location: str
    issues: list[str]
    last_reading_at: str | None


class ScrapeResultOut(BaseModel):
    scraped: int
    stored: int
    rejected: int


class HealthOut(BaseModel):
    status: str
    app: str
    environment: str
