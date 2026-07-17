"""Database engine and session factory."""

from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from ganga_aqua.config import get_settings

_settings = get_settings()

_url = _settings.database_url
_engine_kwargs: dict = {"pool_pre_ping": True}
if _url.startswith("postgresql+psycopg"):
    # Supabase's transaction pooler (pgBouncer) rejects server-side prepared
    # statements; disabling them keeps psycopg3 compatible in serverless.
    _engine_kwargs["connect_args"] = {"prepare_threshold": None}
    # Serverless: many short-lived invocations, don't hoard connections.
    _engine_kwargs["pool_size"] = 1
    _engine_kwargs["max_overflow"] = 2

engine = create_engine(_url, **_engine_kwargs)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
