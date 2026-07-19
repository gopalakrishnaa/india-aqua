"""MPPCB rivers scraper: pure parsing/mapping logic, no network."""

from india_aqua.scrapers.mppcb_rivers import (
    PARAMETER_MAP,
    MPPCBRiversScraper,
    _extract_metrics,
    _normalize_river,
)

_SAMPLE_SLIDE = """
<div class="mySlides" id='{&#x27;station&#x27;: &#x27;Amarkantak&#x27;, &#x27;name&#x27;: &#x27;River Narmada at Origin Point, Amarkantak&#x27;, &#x27;gov_page_url&#x27;: &#x27;https://esc.mp.gov.in/#/publicPortal/industryDetails/site_3308/RTWQMS&#x27;, &#x27;river&#x27;: &#x27;River Narmada&#x27;, &#x27;city&#x27;: &#x27;Amarkantak&#x27;, &#x27;ro&#x27;: &#x27;Shahdol&#x27;, &#x27;latitude&#x27;: 22.684376, &#x27;longitude&#x27;: 81.747056}' value="">
<b class="clr-red">Last Update : </b><b>2026-07-19 11:36:00</b><br>
<table><tbody>
<tr><td></td><td>BOD (mg/l)</td><td><b> 0.88 </b></td></tr>
<tr><td></td><td>COD (mg/l)</td><td><b> 10.88 </b></td></tr>
<tr><td></td><td>Colour (Hazen-eq.)</td><td><b> 12.08 </b></td></tr>
<tr><td></td><td>DO (mg/l)</td><td><b> 0.8 </b></td></tr>
<tr><td></td><td>pH (pH)</td><td><b> 6.88 </b></td></tr>
<tr><td></td><td>Temp. (°C)</td><td><b> 24.4 </b></td></tr>
<tr><td></td><td>TSS (mg/l)</td><td><b> 11.88 </b></td></tr>
</tbody></table>
</div>
"""

_EMPTY_SLIDE = """
<table><tbody>
<tr><td></td><td>BOD (mg/l)</td><td><b> - </b></td></tr>
<tr><td></td><td>DO (mg/l)</td><td><b> - </b></td></tr>
</tbody></table>
"""


def test_requires_no_llm_validation():
    assert MPPCBRiversScraper.requires_llm_validation is False


def test_extract_metrics_maps_known_params_and_keeps_extras():
    metrics, extras = _extract_metrics(_SAMPLE_SLIDE)
    assert metrics == {
        "bod_mg_l": 0.88,
        "cod_mg_l": 10.88,
        "dissolved_oxygen_mg_l": 0.8,
        "ph": 6.88,
        "temperature_c": 24.4,
    }
    assert extras == ["Colour (Hazen-eq.): 12.08", "TSS (mg/l): 11.88"]


def test_extract_metrics_skips_blank_dash_values():
    metrics, extras = _extract_metrics(_EMPTY_SLIDE)
    assert metrics == {}
    assert extras == []


def test_normalize_river_prefers_river_field():
    assert _normalize_river({"river": "River Narmada", "name": "x"}) == "Narmada"


def test_normalize_river_handles_typo_via_substring_match():
    assert _normalize_river({"river": "Narmadapuram River Naramada", "name": "x"}) == "Narmada"


def test_normalize_river_falls_back_to_name_when_river_field_blank():
    assert _normalize_river({"river": "", "name": "River Kshipra upstream city, Ujjain"}) == "Kshipra"


def test_normalize_river_falls_back_to_name_when_river_field_unrelated():
    assert (
        _normalize_river({"river": "Down Stream at Niranjanpur", "name": "River Kanha down stream, Indore"})
        == "Kanha"
    )


def test_normalize_river_defaults_to_narmada_when_nothing_matches():
    assert _normalize_river({"river": "", "name": "Some unrelated station"}) == "Narmada"


def test_parameter_map_covers_schema_fields():
    assert set(PARAMETER_MAP.values()) == {
        "bod_mg_l",
        "cod_mg_l",
        "dissolved_oxygen_mg_l",
        "ph",
        "temperature_c",
    }
