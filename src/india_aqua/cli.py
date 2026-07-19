"""india-aqua CLI."""

from __future__ import annotations

import asyncio
import logging

import typer
import uvicorn
from rich.console import Console
from rich.table import Table

from india_aqua.config import get_settings
from india_aqua.db.base import Base
from india_aqua.db.session import SessionLocal, engine
from india_aqua.services.cpcb_import import run_cpcb_import
from india_aqua.services.ganga_analysis import analyze_ganga_data
from india_aqua.services.ganga_import import import_ganga_workbooks
from india_aqua.services.seed import run_seed

app = typer.Typer(name="india-aqua", help="Indian river water-quality SaaS CLI")
console = Console()


def _setup_logging() -> None:
    settings = get_settings()
    logging.basicConfig(level=getattr(logging, settings.log_level.upper(), logging.INFO))


@app.command()
def initdb() -> None:
    """Create all tables (dev shortcut, prefer alembic in production)."""
    _setup_logging()
    Base.metadata.create_all(bind=engine)
    console.print("[green]Database tables created.[/green]")


@app.command()
def seed() -> None:
    """Seed sample data + bootstrap SaaS client."""
    _setup_logging()
    db = SessionLocal()
    try:
        result = run_seed(db)
        table = Table(title="Seed Results")
        table.add_column("Key")
        table.add_column("Value")
        for key, value in result.items():
            if key == "bootstrap_api_key":
                table.add_row(key, f"[bold yellow]{value}[/bold yellow]")
            else:
                table.add_row(key, str(value))
        console.print(table)
        if "bootstrap_api_key" in result:
            console.print("\n[dim]Save this API key. It won't be shown again.[/dim]")
    finally:
        db.close()


@app.command()
def import_cpcb_report(
    dry_run: bool = typer.Option(False, help="Parse + geocode but don't write to the database"),
) -> None:
    """Import CPCB's 'Polluted River Stretches' report: real river/state/BOD/
    priority data across every assessed state and UT. Run by hand whenever a
    new report edition is published (roughly every 2 years); not part of the
    periodic scrape rotation. Geocoding is rate-limited to Nominatim's 1
    req/sec policy, so a cold run (~300 rows) takes several minutes; results
    are cached in data/cpcb_geocode_cache.json so re-runs are near-instant.
    Safe to re-run: stations are matched by cpcb_code and existing readings
    are never duplicated.
    """
    _setup_logging()
    db = SessionLocal()
    try:
        result = asyncio.run(run_cpcb_import(db, dry_run=dry_run))
        table = Table(title="CPCB Report Import" + (" (dry run)" if dry_run else ""))
        table.add_column("Key")
        table.add_column("Value")
        for key, value in result.items():
            table.add_row(key, str(value))
        console.print(table)
    finally:
        db.close()


@app.command()
def import_ganga_data(output_dir: str = typer.Option("data/ganga", help="Where to download and store the Excel data")) -> None:
    """Download the Excel workbooks published on the Ganga data portal and normalize them."""
    _setup_logging()
    rows = import_ganga_workbooks(output_dir=output_dir)
    console.print(f"Imported {len(rows)} normalized rows from the Ganga portal")


@app.command()
def analyze_ganga_data_file(
    csv_path: str = typer.Argument(..., help="Path to the normalized Ganga CSV created by import_ganga_data"),
) -> None:
    """Summarize the cleaned Ganga dataset and write a markdown report."""
    _setup_logging()
    report = analyze_ganga_data(csv_path)
    console.print(report)


@app.command()
def runserver(
    host: str = typer.Option("0.0.0.0", help="Bind host"),
    port: int = typer.Option(8000, help="Bind port"),
    reload: bool = typer.Option(False, help="Auto-reload on code changes"),
) -> None:
    """Run the FastAPI server."""
    _setup_logging()
    settings = get_settings()
    console.print(f"[cyan]Starting {settings.app_name} API on {host}:{port}[/cyan]")
    uvicorn.run("india_aqua.api.app:app", host=host, port=port, reload=reload)


if __name__ == "__main__":
    app()
