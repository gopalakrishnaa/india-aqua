"""CPCB realtime scraper: pure parsing/mapping logic, no network."""

from india_aqua.scrapers.cpcb_realtime import (
    PARAMETER_MAP,
    CPCBRealtimeScraper,
    _clean_name,
    _extract_river,
)


def test_requires_no_llm_validation():
    assert CPCBRealtimeScraper.requires_llm_validation is False


def test_clean_name_strips_station_prefix_and_nbsp():
    assert _clean_name("BH72_River Ganga at Chausa, U/s of Buxar\xa0") == "River Ganga at Chausa, U/s of Buxar"


def test_clean_name_collapses_whitespace():
    assert _clean_name("UT57_River  Hindon,   City Forest") == "River Hindon, City Forest"


def test_extract_river_matches_named_tributary():
    assert _extract_river("Road Bridge on Gandak, Hajipur") == "Gandak"
    assert _extract_river("River Ganga at Chausa, U/s of Buxar") == "Ganga"


def test_extract_river_defaults_to_ganga_when_unnamed():
    assert _extract_river("Dhari Devi Temple") == "Ganga"


def test_parameter_map_covers_schema_fields():
    assert set(PARAMETER_MAP.values()) == {
        "ph",
        "temperature_c",
        "bod_mg_l",
        "cod_mg_l",
        "dissolved_oxygen_mg_l",
        "turbidity_ntu",
    }
