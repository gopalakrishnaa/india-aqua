# india-aqua

> SaaS-ready, API-first dashboard for **Indian river water quality**. An autonomous
> AI agent scrapes public data, validates it against hallucinations using an LLM at
> `temperature=0`, stores it in PostgreSQL, and visualizes it via Streamlit BI.

---

## What this is

`india-aqua` is a full-stack water-quality intelligence platform built around one idea:
**government data is valuable, but you must never trust a scraper's guess.**

An autonomous agent:

1. **Scrapes** water-quality metrics from public sources (CPCB, Namami Gange, India WRIS)
   using a pluggable Playwright framework.
2. **Validates** every extracted value with an LLM running at `temperature=0`. The LLM acts
   strictly as a validator, asking only *"does this structured data perfectly match the raw
   scraped text, or are there fabricated values?"* If validation fails, the data point is
   logged and **skipped**.
3. **Stores** only validated, traceable readings in PostgreSQL (every row keeps its `source_url`).
4. **Serves** the data via a SaaS API (FastAPI) with API-key auth + per-tier rate limits.
5. **Visualizes** it on a hosted BI dashboard (Streamlit) with three views: current status,
   data deficiency, and trends.

## Tech stack

| Layer        | Choice                                            | Why                                            |
|--------------|---------------------------------------------------|------------------------------------------------|
| Language     | Python 3.11                                       | Single language end-to-end                     |
| LLM          | NVIDIA NIM (OpenAI-compatible, `temperature=0`)  | Deterministic validation, swappable provider   |
| Database     | PostgreSQL (Supabase for hosted SaaS scale)       | Time-series + multi-tenant ready               |
| API          | FastAPI                                           | Fast, async, OpenAPI docs, SaaS-friendly       |
| Scraping     | Playwright                                        | Handles dynamic / JS-heavy gov portals         |
| Dashboard    | Streamlit                                         | Lightweight, ships in the same stack           |
| Deploy       | Docker + GitHub Actions                           | Reproducible, CI-tested                         |

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full design.

## Quick start

```bash
# 1. Install (uv manages the venv)
cp .env.example .env       # fill in DATABASE_URL + NVIDIA_API_KEY
uv sync                    # install deps
uv run playwright install chromium   # browser for live scraping

# 2. Database (uses your DATABASE_URL, e.g. a Supabase project)
uv run alembic upgrade head

# 3. Seed realistic sample data
uv run india-aqua seed

# 4. Run the API + dashboard
uv run india-aqua runserver          # FastAPI on :8000
uv run streamlit run dashboard/app.py # Streamlit on :8501
```

API docs: `http://localhost:8000/docs` · Dashboard: `http://localhost:8501`

## Project layout

```
india-aqua/
├── src/india_aqua/   # config, db models, agents, scrapers, services, api, cli
├── dashboard/        # Streamlit BI app
├── sql/              # raw SQL schema + views + Supabase setup guide
├── alembic/          # migrations
├── docker/           # Dockerfiles for api + dashboard
├── tests/            # unit + integration tests
└── .github/workflows/ci.yml
```

## Security

- `.env` is gitignored; secrets (DB URL, NVIDIA key) are read **only** from environment variables.
- SaaS API access requires an `X-API-Key` (stored hashed in `saas_clients`); requests are rate-limited per tier.
- No secrets are ever baked into Docker images or CI configs.

## License

MIT
