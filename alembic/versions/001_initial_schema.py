"""Initial schema

Revision ID: 001
Revises:
Create Date: 2026-07-15

"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "monitoring_stations",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=200), nullable=False),
        sa.Column("river", sa.String(length=100), nullable=False),
        sa.Column("location", sa.String(length=200), nullable=False),
        sa.Column("latitude", sa.Float(), nullable=True),
        sa.Column("longitude", sa.Float(), nullable=True),
        sa.Column("cpcb_code", sa.String(length=50), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("cpcb_code"),
    )
    op.create_table(
        "saas_clients",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=200), nullable=False),
        sa.Column("api_key_hash", sa.String(length=128), nullable=False),
        sa.Column("tier", sa.Enum("free", "pro", "enterprise", name="saastier"), nullable=False),
        sa.Column("rate_limit", sa.String(length=50), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("api_key_hash"),
    )
    op.create_table(
        "validation_logs",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("station_id", sa.Integer(), nullable=True),
        sa.Column("raw_text", sa.Text(), nullable=False),
        sa.Column("extracted_json", sa.Text(), nullable=True),
        sa.Column("reason", sa.Text(), nullable=False),
        sa.Column("source_url", sa.String(length=500), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["station_id"], ["monitoring_stations.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "water_quality_readings",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("station_id", sa.Integer(), nullable=False),
        sa.Column("ph", sa.Float(), nullable=True),
        sa.Column("dissolved_oxygen_mg_l", sa.Float(), nullable=True),
        sa.Column("bod_mg_l", sa.Float(), nullable=True),
        sa.Column("cod_mg_l", sa.Float(), nullable=True),
        sa.Column("turbidity_ntu", sa.Float(), nullable=True),
        sa.Column("temperature_c", sa.Float(), nullable=True),
        sa.Column("recorded_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("source_url", sa.String(length=500), nullable=False),
        sa.Column("raw_text", sa.Text(), nullable=True),
        sa.Column("validated_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["station_id"], ["monitoring_stations.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_readings_station_recorded", "water_quality_readings", ["station_id", "recorded_at"])


def downgrade() -> None:
    op.drop_index("ix_readings_station_recorded", table_name="water_quality_readings")
    op.drop_table("water_quality_readings")
    op.drop_table("validation_logs")
    op.drop_table("saas_clients")
    op.drop_table("monitoring_stations")
    op.execute("DROP TYPE IF EXISTS saastier")
