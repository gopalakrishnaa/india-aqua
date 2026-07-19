from __future__ import annotations

import pandas as pd

from india_aqua.services.ganga_import import normalize_workbook


def test_normalize_workbook_converts_monthly_sheet_to_long_format(tmp_path):
    workbook_path = tmp_path / "demo.xlsx"
    with pd.ExcelWriter(workbook_path) as writer:
        sheet = pd.DataFrame(
            [
                [None, None, None, None, None, None, None],
                [None, None, "January", None, "February", None, None],
                ["Sr.No", "STN Code", "Station me", "First round", "Second round", "First round", "Second round"],
                [1, 1001, "Station A", 1.2, None, 3.4, 2.1],
                [2, 1002, "Station B", None, 1.5, 2.0, 5.0],
            ]
        )
        sheet.to_excel(writer, sheet_name="Demo", header=False, index=False)

    rows = normalize_workbook(
        workbook_path,
        metric="BOD",
        state="Test",
        source_url="https://example.com/demo.xlsx",
    )

    assert len(rows) >= 4
    assert rows[0]["metric"] == "BOD"
    assert rows[0]["state"] == "Test"
    assert rows[0]["month"] == "January"
    assert rows[0]["round"] == "first"
    assert rows[0]["value"] == 1.2
    assert rows[0]["station_name"] == "Station A"
