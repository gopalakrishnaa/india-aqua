"""Utilities for downloading and normalizing Ganga water-quality Excel files."""

from __future__ import annotations

import logging
import re
from pathlib import Path
from typing import Any
from urllib.parse import urljoin

import pandas as pd
import requests

logger = logging.getLogger(__name__)

BASE_URL = "https://gyanganga.ai/"


def _coerce_numeric(value: Any) -> float | None:
    """Return a numeric float for common Ganga workbook cell values or None if unavailable."""
    if value is None or pd.isna(value):
        return None
    if isinstance(value, (int, float)):
        return float(value)

    text = str(value).strip()
    if not text:
        return None
    text = text.replace(",", "")
    text = text.replace(" ", "")
    if re.search(r"\b(bdl|belowdetectionlimit|notdetected|nil|n/a|na)\b", text, flags=re.IGNORECASE):
        return None
    match = re.search(r"[-+]?\d*\.?\d+", text)
    if not match:
        return None
    try:
        return float(match.group(0))
    except ValueError:
        return None


def normalize_workbook(
    workbook_path: str | Path,
    *,
    metric: str,
    state: str,
    source_url: str,
) -> list[dict[str, Any]]:
    """Convert a Ganga-style Excel workbook into a list of normalized row dictionaries."""
    workbook_path = Path(workbook_path)
    excel_file = pd.ExcelFile(workbook_path)
    rows: list[dict[str, Any]] = []

    for sheet_name in excel_file.sheet_names:
        sheet_df = pd.read_excel(workbook_path, sheet_name=sheet_name, header=None)
        if sheet_df.empty:
            continue

        # Try to locate the row that contains month labels and the row that contains station metadata.
        month_row = None
        header_row = None
        for idx in range(min(5, len(sheet_df))):
            values = [str(v).strip() if pd.notna(v) else "" for v in sheet_df.iloc[idx].tolist()]
            if any("january" in v.lower() for v in values):
                month_row = idx
            if any("station" in v.lower() for v in values) and any("sr.no" in v.lower() for v in values):
                header_row = idx

        if month_row is None or header_row is None:
            continue

        month_names = []
        for cell in sheet_df.iloc[month_row].tolist():
            if pd.isna(cell):
                continue
            text = str(cell).strip().lower()
            if text in {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"}:
                month_names.append(text.title())

        for row_idx in range(header_row + 1, len(sheet_df)):
            row_values = sheet_df.iloc[row_idx].tolist()
            if len(row_values) < 3:
                continue
            station_name = row_values[2]
            if pd.isna(station_name) or str(station_name).strip() == "":
                continue
            station_code = row_values[1]
            for col_idx, value in enumerate(row_values[3:], start=3):
                numeric_value = _coerce_numeric(value)
                if numeric_value is None:
                    continue
                month_name = month_names[col_idx - 3] if col_idx - 3 < len(month_names) else None
                if month_name is None:
                    continue
                round_label = "first" if (col_idx - 3) % 2 == 0 else "second"
                rows.append(
                    {
                        "sheet": sheet_name,
                        "state": state,
                        "metric": metric,
                        "station_code": station_code,
                        "station_name": str(station_name).strip(),
                        "month": month_name,
                        "round": round_label,
                        "value": numeric_value,
                        "source_url": source_url,
                        "source_file": workbook_path.name,
                    }
                )
    return rows


def import_ganga_workbooks(output_dir: str | Path | None = None) -> list[dict[str, Any]]:
    """Download the published Ganga Excel files and normalize them into a structured dataset."""
    output_dir = Path(output_dir or "data/ganga")
    output_dir.mkdir(parents=True, exist_ok=True)

    html = requests.get(BASE_URL + "Ganga-Water-Quality-Data.aspx", timeout=60).text
    workbook_links = re.findall(r"admin//fileupload//[^\"'\s<>]+\.xlsx", html, re.IGNORECASE)
    all_rows: list[dict[str, Any]] = []

    for relative_path in workbook_links:
        url = urljoin(BASE_URL, relative_path.replace("//", "/"))
        filename = Path(relative_path).name
        local_path = output_dir / filename
        logger.info("Downloading %s", url)
        response = requests.get(url, timeout=90)
        response.raise_for_status()
        local_path.write_bytes(response.content)

        metric = "unknown"
        if "BOD" in filename.upper():
            metric = "BOD"
        elif "DO" in filename.upper():
            metric = "DO"
        elif "PH" in filename.upper() or "pH" in filename.upper():
            metric = "pH"
        elif "FC" in filename.upper():
            metric = "FC"
        elif "FS" in filename.upper():
            metric = "FS"
        elif "BIOMONITOR" in filename.upper():
            metric = "BIOMONITORING"

        state_match = re.search(r"(Uttarakhand|Uttar Pradesh|Bihar|Jharkhand|West Bengal|UK|UP|WB|BH|JH)", filename, re.IGNORECASE)
        state = state_match.group(1).strip() if state_match else "Unknown"
        rows = normalize_workbook(local_path, metric=metric, state=state, source_url=url)
        all_rows.extend(rows)

    data_frame = pd.DataFrame(all_rows)
    if not data_frame.empty:
        csv_path = output_dir / "ganga_water_quality.csv"
        data_frame.to_csv(csv_path, index=False)
        logger.info("Wrote %s rows to %s", len(all_rows), csv_path)

    return all_rows
