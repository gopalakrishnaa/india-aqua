-- Ganga Aqua PostgreSQL schema (reference — Alembic is source of truth for migrations)

CREATE TABLE IF NOT EXISTS monitoring_stations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    river VARCHAR(100) NOT NULL DEFAULT 'Ganga',
    location VARCHAR(200) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    cpcb_code VARCHAR(50) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS water_quality_readings (
    id SERIAL PRIMARY KEY,
    station_id INTEGER NOT NULL REFERENCES monitoring_stations(id),
    ph DOUBLE PRECISION,
    dissolved_oxygen_mg_l DOUBLE PRECISION,
    bod_mg_l DOUBLE PRECISION,
    cod_mg_l DOUBLE PRECISION,
    turbidity_ntu DOUBLE PRECISION,
    temperature_c DOUBLE PRECISION,
    recorded_at TIMESTAMPTZ NOT NULL,
    source_url VARCHAR(500) NOT NULL,
    raw_text TEXT,
    validated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_readings_station_recorded
    ON water_quality_readings (station_id, recorded_at DESC);
