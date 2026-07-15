"""WQI analyzer tests (deterministic compute + mocked LLM)."""

from unittest.mock import MagicMock

from ganga_aqua.agents.analyzer import (
    AnalysisResult,
    WQIAnalyzer,
    classify_wqi,
    compute_wqi,
)

CLEAN = {"ph": 7.0, "dissolved_oxygen_mg_l": 8.5, "bod_mg_l": 1.0, "turbidity_ntu": 4.0}
DIRTY = {"ph": 9.6, "dissolved_oxygen_mg_l": 2.0, "bod_mg_l": 14.0, "turbidity_ntu": 140.0}


def test_compute_wqi_clean_is_high():
    assert compute_wqi(CLEAN) > 90


def test_compute_wqi_dirty_is_low():
    assert compute_wqi(DIRTY) < 20


def test_compute_wqi_none_without_metrics():
    assert compute_wqi({"temperature_c": 25.0}) is None


def test_classify_thresholds():
    assert classify_wqi(85) == "Good"
    assert classify_wqi(60) == "Moderate"
    assert classify_wqi(30) == "Poor"
    assert classify_wqi(10) == "Unfit"


def test_analyze_falls_back_to_rule_based_without_client():
    analyzer = WQIAnalyzer.__new__(WQIAnalyzer)
    analyzer._client = None
    result = analyzer.analyze(CLEAN)
    assert isinstance(result, AnalysisResult)
    assert result.quality_class == "Good"
    assert result.llm_used is False


def test_analyze_uses_llm_class_when_available():
    analyzer = WQIAnalyzer.__new__(WQIAnalyzer)
    analyzer._model = "test-model"
    analyzer._temperature = 0.0
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(message=MagicMock(content='{"quality_class": "Good", "note": "clean"}'))
    ]
    analyzer._client = MagicMock()
    analyzer._client.chat.completions.create.return_value = mock_response

    result = analyzer.analyze(CLEAN)
    assert result.quality_class == "Good"
    assert result.note == "clean"
    assert result.llm_used is True
