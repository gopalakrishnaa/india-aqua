"""Pytest fixtures."""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from ganga_aqua.api.app import create_app
from ganga_aqua.db.base import Base
from ganga_aqua.db.session import get_db
from ganga_aqua.services.auth import create_client, generate_api_key
from ganga_aqua.services.seed import run_seed


@pytest.fixture()
def db_session():
    engine = create_engine(
        "sqlite+pysqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    session_factory = sessionmaker(bind=engine)
    session = session_factory()
    try:
        yield session
    finally:
        session.close()


@pytest.fixture()
def api_client(db_session):
    app = create_app()

    def _override_db():
        yield db_session

    app.dependency_overrides[get_db] = _override_db
    api_key = generate_api_key("test")
    create_client(db_session, name="test-client", raw_key=api_key)
    run_seed(db_session)
    client = TestClient(app)
    client.headers.update({"X-API-Key": api_key})
    yield client
    app.dependency_overrides.clear()
