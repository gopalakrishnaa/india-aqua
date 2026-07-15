"""LLM hallucination validator — temperature=0, strict match check."""

from __future__ import annotations

import json
import logging
from typing import Any

from openai import OpenAI
from pydantic import BaseModel, Field
from tenacity import retry, stop_after_attempt, wait_exponential

from ganga_aqua.config import get_settings

logger = logging.getLogger(__name__)

VALIDATION_SYSTEM_PROMPT = """You are a strict data validation agent for Ganga River water quality readings.
Your ONLY job: decide whether extracted structured values PERFECTLY match the raw scraped text.

Rules:
- Compare each numeric field in the extracted JSON against what appears in raw_text.
- If any value is fabricated, inferred, rounded differently, or missing from raw_text → REJECT.
- If raw_text is ambiguous or incomplete for a claimed field → REJECT that field (fail overall if critical).
- Do NOT invent or correct values. You validate only.
- Respond with valid JSON only, no markdown.

Response schema:
{
  "valid": true|false,
  "reason": "brief explanation",
  "mismatched_fields": ["field_name", ...]
}
"""


class ValidationResult(BaseModel):
    valid: bool
    reason: str = ""
    mismatched_fields: list[str] = Field(default_factory=list)


class LLMValidator:
    def __init__(self) -> None:
        settings = get_settings()
        self._client = OpenAI(
            api_key=settings.nvidia_api_key,
            base_url=settings.nvidia_base_url,
        )
        self._model = settings.nvidia_model
        self._temperature = settings.llm_temperature

    @retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=1, max=8))
    def validate(self, raw_text: str, extracted: dict[str, Any]) -> ValidationResult:
        user_prompt = (
            f"RAW SCRAPED TEXT:\n{raw_text}\n\n"
            f"EXTRACTED JSON:\n{json.dumps(extracted, indent=2)}\n\n"
            "Does the extracted JSON perfectly match the raw text? Respond with JSON only."
        )
        response = self._client.chat.completions.create(
            model=self._model,
            temperature=self._temperature,
            messages=[
                {"role": "system", "content": VALIDATION_SYSTEM_PROMPT},
                {"role": "user", "content": user_prompt},
            ],
            max_tokens=512,
        )
        content = response.choices[0].message.content or "{}"
        content = content.strip()
        if content.startswith("```"):
            content = content.split("\n", 1)[-1].rsplit("```", 1)[0].strip()
        try:
            data = json.loads(content)
            return ValidationResult(**data)
        except (json.JSONDecodeError, TypeError, ValueError) as exc:
            logger.warning("LLM returned unparseable validation response: %s", exc)
            return ValidationResult(valid=False, reason=f"Unparseable LLM response: {content[:200]}")
