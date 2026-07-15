"""API route handlers."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from ganga_aqua.api.deps import get_current_client
from ganga_aqua.api.schemas import DeficiencyOut, ReadingOut, ScrapeResultOut, StationOut
from ganga_aqua.db.models import SaasClient
from ganga_aqua.db.session import get_db
from ganga_aqua.services.readings import (
    get_deficiency_report,
    get_latest_readings,
    get_readings_history,
    list_rivers,
    list_stations,
)
from ganga_aqua.services.scrape_pipeline import run_scrape_pipeline

router = APIRouter(prefix="/api/v1", tags=["water-quality"])


def _reading_to_out(reading) -> ReadingOut:
    return ReadingOut(
        id=reading.id,
        station_id=reading.station_id,
        station_name=reading.station.name if reading.station else None,
        ph=reading.ph,
        dissolved_oxygen_mg_l=reading.dissolved_oxygen_mg_l,
        bod_mg_l=reading.bod_mg_l,
        cod_mg_l=reading.cod_mg_l,
        turbidity_ntu=reading.turbidity_ntu,
        temperature_c=reading.temperature_c,
        wqi=reading.wqi,
        quality_class=reading.quality_class,
        recorded_at=reading.recorded_at,
        source_url=reading.source_url,
    )


@router.get("/stations", response_model=list[StationOut])
def api_list_stations(
    river: str | None = Query(default=None, description="Filter by river name"),
    db: Session = Depends(get_db),
    _client: SaasClient = Depends(get_current_client),
):
    return list_stations(db, river)


@router.get("/rivers", response_model=list[str])
def api_list_rivers(
    db: Session = Depends(get_db),
    _client: SaasClient = Depends(get_current_client),
):
    return list_rivers(db)


@router.get("/readings/latest", response_model=list[ReadingOut])
def api_latest_readings(
    station_id: int | None = Query(default=None),
    db: Session = Depends(get_db),
    _client: SaasClient = Depends(get_current_client),
):
    return [_reading_to_out(r) for r in get_latest_readings(db, station_id)]


@router.get("/readings/history", response_model=list[ReadingOut])
def api_readings_history(
    station_id: int | None = Query(default=None),
    days: int = Query(default=30, ge=1, le=365),
    limit: int = Query(default=500, ge=1, le=2000),
    db: Session = Depends(get_db),
    _client: SaasClient = Depends(get_current_client),
):
    return [_reading_to_out(r) for r in get_readings_history(db, station_id, days, limit)]


@router.get("/deficiency", response_model=list[DeficiencyOut])
def api_deficiency(
    db: Session = Depends(get_db),
    _client: SaasClient = Depends(get_current_client),
):
    return get_deficiency_report(db)


@router.post("/scrape", response_model=ScrapeResultOut)
async def api_trigger_scrape(
    demo: bool = Query(default=False, description="Use demo scraper (skip Playwright)"),
    db: Session = Depends(get_db),
    client: SaasClient = Depends(get_current_client),
):
    if client.tier.value not in ("pro", "enterprise"):
        from fastapi import HTTPException

        raise HTTPException(status_code=403, detail="Scrape trigger requires pro or enterprise tier")
    result = await run_scrape_pipeline(db, use_playwright=not demo)
    return ScrapeResultOut(**result)
