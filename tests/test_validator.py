"""LLM validator unit tests (mocked)."""

from unittest.mock import MagicMock, patch

from ganga_aqua.agents.validator import LLMValidator, ValidationResult


def test_validation_accepts_match():
    validator = LLMValidator.__new__(LLMValidator)
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(message=MagicMock(content='{"valid": true, "reason": "All fields match", "mismatched_fields": []}'))
    ]
    validator._client = MagicMock()
    validator._client.chat.completions.create.return_value = mock_response
    validator._model = "test-model"
    validator._temperature = 0.0

    result = validator.validate(
        raw_text="pH: 7.2\nDO: 5.5 mg/L",
        extracted={"ph": 7.2, "dissolved_oxygen_mg_l": 5.5},
    )
    assert result.valid is True
    assert result.reason == "All fields match"


def test_validation_rejects_mismatch():
    validator = LLMValidator.__new__(LLMValidator)
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(
            message=MagicMock(
                content='{"valid": false, "reason": "pH not in raw text", "mismatched_fields": ["ph"]}'
            )
        )
    ]
    validator._client = MagicMock()
    validator._client.chat.completions.create.return_value = mock_response
    validator._model = "test-model"
    validator._temperature = 0.0

    result = validator.validate(raw_text="DO: 5.5", extracted={"ph": 7.2})
    assert result.valid is False
    assert "ph" in result.mismatched_fields
