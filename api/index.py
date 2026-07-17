"""Vercel serverless entrypoint — exposes the FastAPI app as ASGI.

Vercel's Python runtime installs requirements.txt (slim, no Playwright)
and bundles the repo; src/ isn't pip-installed, so put it on sys.path.
"""

import os
import sys

_HERE = os.path.dirname(__file__)
sys.path.insert(0, os.path.join(_HERE, "..", "src"))

# No managed Postgres wired yet: fall back to the pre-seeded read-only
# SQLite bundled beside this file. An absolute path keeps it valid whatever
# the serverless working directory is. A real DATABASE_URL (postgres) wins.
if not os.environ.get("DATABASE_URL"):
    os.environ["DATABASE_URL"] = "sqlite:///" + os.path.join(_HERE, "seed.db")

from ganga_aqua.api.app import app  # noqa: E402, F401
