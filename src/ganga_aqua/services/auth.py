"""API key hashing and client lookup."""

from __future__ import annotations

import hashlib
import secrets

from sqlalchemy.orm import Session

from ganga_aqua.config import get_settings
from ganga_aqua.db.models import SaasClient, SaasTier


def hash_api_key(raw_key: str) -> str:
    secret = get_settings().api_key_secret
    return hashlib.sha256(f"{secret}:{raw_key}".encode()).hexdigest()


def generate_api_key(prefix: str = "gaq") -> str:
    return f"{prefix}_{secrets.token_urlsafe(32)}"


def get_client_by_api_key(db: Session, raw_key: str) -> SaasClient | None:
    key_hash = hash_api_key(raw_key)
    return db.query(SaasClient).filter(SaasClient.api_key_hash == key_hash, SaasClient.is_active).first()


def create_client(
    db: Session,
    name: str,
    raw_key: str,
    tier: SaasTier = SaasTier.FREE,
    rate_limit: str | None = None,
) -> SaasClient:
    settings = get_settings()
    client = SaasClient(
        name=name,
        api_key_hash=hash_api_key(raw_key),
        tier=tier,
        rate_limit=rate_limit or settings.default_rate_limit,
    )
    db.add(client)
    db.commit()
    db.refresh(client)
    return client
