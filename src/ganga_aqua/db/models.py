"""SQLAlchemy ORM models."""

from __future__ import annotations

import enum
from datetime import datetime

from sqlalchemy import (
    Boolean,
    DateTime,
    Enum,
    Float,
    ForeignKey,
    Index,
    String,
    Text,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from ganga_aqua.db.base import Base


class SaasTier(str, enum.Enum):
    FREE = "free"
    PRO = "pro"
    ENTERPRISE = "enterprise"


class MonitoringStation(Base):
    __tablename__ = "monitoring_stations"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    river: Mapped[str] = mapped_column(String(100), default="Ganga")
    location: Mapped[str] = mapped_column(String(200), nullable=False)
    latitude: Mapped[float | None] = mapped_column(Float)
    longitude: Mapped[float | None] = mapped_column(Float)
    cpcb_code: Mapped[str | None] = mapped_column(String(50), unique=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    readings: Mapped[list[WaterQualityReading]] = relationship(back_populates="station")


class WaterQualityReading(Base):
    __tablename__ = "water_quality_readings"
    __table_args__ = (Index("ix_readings_station_recorded", "station_id", "recorded_at"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    station_id: Mapped[int] = mapped_column(ForeignKey("monitoring_stations.id"), nullable=False)
    ph: Mapped[float | None] = mapped_column(Float)
    dissolved_oxygen_mg_l: Mapped[float | None] = mapped_column(Float)
    bod_mg_l: Mapped[float | None] = mapped_column(Float)
    cod_mg_l: Mapped[float | None] = mapped_column(Float)
    turbidity_ntu: Mapped[float | None] = mapped_column(Float)
    temperature_c: Mapped[float | None] = mapped_column(Float)
    recorded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    source_url: Mapped[str] = mapped_column(String(500), nullable=False)
    raw_text: Mapped[str | None] = mapped_column(Text)
    validated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    station: Mapped[MonitoringStation] = relationship(back_populates="readings")


class ValidationLog(Base):
    __tablename__ = "validation_logs"

    id: Mapped[int] = mapped_column(primary_key=True)
    station_id: Mapped[int | None] = mapped_column(ForeignKey("monitoring_stations.id"))
    raw_text: Mapped[str] = mapped_column(Text, nullable=False)
    extracted_json: Mapped[str | None] = mapped_column(Text)
    reason: Mapped[str] = mapped_column(Text, nullable=False)
    source_url: Mapped[str] = mapped_column(String(500), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class SaasClient(Base):
    __tablename__ = "saas_clients"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    api_key_hash: Mapped[str] = mapped_column(String(128), unique=True, nullable=False)
    tier: Mapped[SaasTier] = mapped_column(Enum(SaasTier, native_enum=False), default=SaasTier.FREE)
    rate_limit: Mapped[str] = mapped_column(String(50), default="60/minute")
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
