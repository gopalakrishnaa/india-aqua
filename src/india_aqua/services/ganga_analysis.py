"""Simple analysis helpers for the normalized Ganga water-quality data."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import pandas as pd


def analyze_ganga_data(csv_path: str | Path) -> str:
    """Load a normalized Ganga CSV and return a short markdown report."""
    data = pd.read_csv(csv_path)
    if data.empty:
        return "No usable rows were found in the provided Ganga CSV."

    report_lines: list[str] = []
    report_lines.append("# Ganga Water Quality Analysis")
    report_lines.append("")
    report_lines.append(f"- Rows loaded: {len(data)}")
    report_lines.append(f"- Metrics present: {', '.join(sorted(data['metric'].dropna().astype(str).unique().tolist()))}")
    report_lines.append(f"- Stations covered: {data['station_name'].nunique()}")
    report_lines.append(f"- States covered: {', '.join(sorted(data['state'].dropna().astype(str).unique().tolist()))}")
    report_lines.append("")
    report_lines.append("## Top stations by average value")
    avg_values = data.groupby("station_name")["value"].mean().sort_values(ascending=False)
    for station_name, avg in avg_values.head(10).items():
        report_lines.append(f"- {station_name}: {avg:.2f}")
    report_lines.append("")
    report_lines.append("## Metric summary")
    for metric, subset in data.groupby("metric"):
        report_lines.append(f"- {metric}: mean={subset['value'].mean():.2f}, max={subset['value'].max():.2f}")
    return "\n".join(report_lines)
