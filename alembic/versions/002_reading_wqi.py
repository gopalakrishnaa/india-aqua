"""Add WQI + quality_class to water_quality_readings

Revision ID: 002
Revises: 001
Create Date: 2026-07-15

"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "002"
down_revision: Union[str, None] = "001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("water_quality_readings", sa.Column("wqi", sa.Float(), nullable=True))
    op.add_column("water_quality_readings", sa.Column("quality_class", sa.String(length=20), nullable=True))


def downgrade() -> None:
    op.drop_column("water_quality_readings", "quality_class")
    op.drop_column("water_quality_readings", "wqi")
