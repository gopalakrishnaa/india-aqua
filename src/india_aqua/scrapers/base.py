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
    river: str = "Ganga"
    metrics: dict[str, Any] = field(default_factory=dict)
    cpcb_code: str | None = None
    latitude: float | None = None
    longitude: float | None = None


class BaseScraper(ABC):
    name: str = "base"
    # Whether readings from this source need the LLM hallucination validator.
    # That validator's job is catching an LLM fabricating numbers while
    # extracting them from messy scraped prose. Irrelevant for scrapers that
    # read a source's own structured JSON/table data directly (nothing was
    # "extracted" by an LLM in the first place).
    requires_llm_validation: bool = True

    @abstractmethod
    async def scrape(self) -> list[ScrapedReading]:
        pass
