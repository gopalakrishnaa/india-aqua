"""Application settings loaded from environment variables."""

from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    app_name: str = "ganga-aqua"
    environment: str = "development"
    log_level: str = "INFO"

    database_url: str = "postgresql+psycopg://postgres:postgres@localhost:5432/ganga_aqua"
    database_migration_url: str | None = None

    @field_validator("database_url", "database_migration_url")
    @classmethod
    def _use_psycopg_driver(cls, v: str | None) -> str | None:
        # Managed hosts (Render, Heroku-style) hand out bare postgres:// / postgresql:// URLs.
        if v and v.startswith("postgres://"):
            return "postgresql+psycopg://" + v[len("postgres://") :]
        if v and v.startswith("postgresql://"):
            return "postgresql+psycopg://" + v[len("postgresql://") :]
        return v

    llm_provider: str = "nvidia"
    nvidia_api_key: str = ""
    nvidia_base_url: str = "https://integrate.api.nvidia.com/v1"
    nvidia_model: str = "meta/llama-3.1-70b-instruct"
    llm_temperature: float = 0.0

    api_key_secret: str = "change-me-to-a-long-random-secret"
    default_rate_limit: str = "60/minute"
    bootstrap_api_key: str = ""

    cors_origins: str = "http://localhost:8501,http://localhost:3000"

    scraper_headless: bool = True
    scraper_timeout_ms: int = 30000

    api_base_url: str = "http://localhost:8000"

    @property
    def migration_url(self) -> str:
        return self.database_migration_url or self.database_url

    @property
    def cors_origin_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
