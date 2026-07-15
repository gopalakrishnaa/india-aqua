"""Base scraper interface."""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from typing import Any


@dataclass
class ScrapedReading:
    station_name: str
    location: str
    source_url: str
    raw_text: str
    recorded_at: datetime
    metrics: dict[str, Any] = field(default_factory=dict)
    cpcb_code: str | None = None
    latitude: float | None = None
    longitude: float | None = None


class BaseScraper(ABC):
    name: str = "base"

    @abstractmethod
    async def scrape(self) -> list[ScrapedReading]:
        pass
