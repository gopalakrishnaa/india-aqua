"""FastAPI dependencies."""

from __future__ import annotations

from fastapi import Depends, Header, HTTPException, Request, status
from sqlalchemy.orm import Session

from ganga_aqua.db.models import SaasClient
from ganga_aqua.db.session import get_db
from ganga_aqua.services.auth import get_client_by_api_key


def get_current_client(
    request: Request,
    x_api_key: str | None = Header(default=None, alias="X-API-Key"),
    db: Session = Depends(get_db),
) -> SaasClient:
    if not x_api_key:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing X-API-Key header")
    client = get_client_by_api_key(db, x_api_key)
    if not client:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid API key")
    request.state.client = client
    return client
