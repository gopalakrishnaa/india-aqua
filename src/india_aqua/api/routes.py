"""API route handlers."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Header, HTTPException, Query
from sqlalchemy.orm import Session

from india_aqua.api.deps import get_current_client
from india_aqua.api.schemas import DeficiencyOut, ReadingOut, ScrapeResultOut, StationOut
from india_aqua.config import get_settings
from india_aqua.db.models import SaasClient
from india_aqua.db.session import get_db
from india_aqua.services.readings import (
    get_deficiency_report,
    get_latest_readings,
    get_readings_history,
    list_rivers,
    list_stations,
)
from india_aqua.services.scrape_pipeline import run_scrape_pipeline

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
    demo: bool = Query(default=False, description="Use synthetic demo data instead of the live CPCB feed"),
    db: Session = Depends(get_db),
    client: SaasClient = Depends(get_current_client),
):
    if client.tier.value not in ("pro", "enterprise"):
        raise HTTPException(status_code=403, detail="Scrape trigger requires pro or enterprise tier")
    result = await run_scrape_pipeline(db, source="demo" if demo else "cpcb_realtime")
    return ScrapeResultOut(**result)


@router.get("/internal/cron/scrape", response_model=ScrapeResultOut, include_in_schema=False)
async def cron_trigger_scrape(
    authorization: str | None = Header(default=None),
    db: Session = Depends(get_db),
):
    """Scheduled entry point for Vercel Cron (GET-only, no per-client API key).
    Vercel automatically sends `Authorization: Bearer $CRON_SECRET` on cron
    requests when a CRON_SECRET env var is set on the project — that's the
    only thing guarding this, not the SaaS tier system (not a client-facing
    feature). Disabled entirely (404) if CRON_SECRET isn't set, so a
    misconfigured deploy fails closed rather than exposing an unauthenticated
    write endpoint."""
    settings = get_settings()
    if not settings.cron_secret:
        raise HTTPException(status_code=404, detail="Not found")
    if authorization != f"Bearer {settings.cron_secret}":
        raise HTTPException(status_code=401, detail="Invalid cron secret")
    result = await run_scrape_pipeline(db, source="cpcb_realtime")
    return ScrapeResultOut(**result)


@router.get("/internal/cron/ganga", include_in_schema=False)
async def cron_trigger_ganga_refresh(
    authorization: str | None = Header(default=None),
):
    """Refresh the Ganga Excel data on a schedule via a cron job."""
    settings = get_settings()
    if not settings.cron_secret:
        raise HTTPException(status_code=404, detail="Not found")
    if authorization != f"Bearer {settings.cron_secret}":
        raise HTTPException(status_code=401, detail="Invalid cron secret")
    # Imported lazily: pandas is excluded from requirements.txt's slim Vercel
    # bundle (see comment there), so importing this at module load would
    # break every route, not just this one.
    from india_aqua.services.ganga_import import import_ganga_workbooks

    rows = import_ganga_workbooks("data/ganga")
    return {"refreshed": True, "rows_imported": len(rows)}
