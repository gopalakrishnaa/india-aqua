"""FastAPI application factory."""

from __future__ import annotations

import logging

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.util import get_remote_address

from ganga_aqua.api.routes import router
from ganga_aqua.api.schemas import HealthOut
from ganga_aqua.config import get_settings

logger = logging.getLogger(__name__)
limiter = Limiter(key_func=get_remote_address)


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        description="Ganga River water-quality SaaS API",
        version="0.1.0",
    )
    app.state.limiter = limiter
    app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origin_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.get("/health", response_model=HealthOut, tags=["health"])
    @limiter.limit("120/minute")
    def health(request: Request):  # slowapi needs request
        return HealthOut(status="ok", app=settings.app_name, environment=settings.environment)

    app.include_router(router)
    return app


app = create_app()
