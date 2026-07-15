"""ganga-aqua CLI."""

from __future__ import annotations

import logging

import typer
import uvicorn
from rich.console import Console
from rich.table import Table

from ganga_aqua.config import get_settings
from ganga_aqua.db.base import Base
from ganga_aqua.db.session import SessionLocal, engine
from ganga_aqua.services.seed import run_seed

app = typer.Typer(name="ganga-aqua", help="Ganga River water-quality SaaS CLI")
console = Console()


def _setup_logging() -> None:
    settings = get_settings()
    logging.basicConfig(level=getattr(logging, settings.log_level.upper(), logging.INFO))


@app.command()
def initdb() -> None:
    """Create all tables (dev shortcut — prefer alembic in production)."""
    _setup_logging()
    Base.metadata.create_all(bind=engine)
    console.print("[green]Database tables created.[/green]")


@app.command()
def seed() -> None:
    """Seed Ganga sample data + bootstrap SaaS client."""
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
            console.print("\n[dim]Save this API key — it won't be shown again.[/dim]")
    finally:
        db.close()


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
    uvicorn.run("ganga_aqua.api.app:app", host=host, port=port, reload=reload)


if __name__ == "__main__":
    app()
