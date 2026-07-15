"""Water Quality Index analyzer agent.

WQI is computed deterministically (LLMs are unreliable at arithmetic), and an
LLM agent at temperature=0 assigns the qualitative class + a short note. If the
LLM is unavailable, a deterministic threshold classifier is used as fallback.
"""

from __future__ import annotations

import json
import logging
from typing import Any

from openai import OpenAI
from pydantic import BaseModel
from tenacity import retry, stop_after_attempt, wait_exponential

from ganga_aqua.config import get_settings

logger = logging.getLogger(__name__)

QUALITY_CLASSES = ["Good", "Moderate", "Poor", "Unfit"]

ANALYSIS_SYSTEM_PROMPT = """You are a water-quality analysis agent for Indian rivers.
You are given the numeric water-quality metrics for a single reading and a
pre-computed Water Quality Index (WQI, 0-100, higher is better).

Your ONLY job: assign a quality class and a one-line note. Do NOT recompute the
WQI or invent metrics you were not given.

Classify using the WQI:
- WQI >= 80  -> "Good"
- 50-79      -> "Moderate"
- 25-49      -> "Poor"
- < 25       -> "Unfit"

Respond with valid JSON only, no markdown:
{"quality_class": "Good|Moderate|Poor|Unfit", "note": "brief plain-language note"}
"""


class AnalysisResult(BaseModel):
    wqi: float
    quality_class: str
    note: str = ""
    llm_used: bool = False


def _sub_index_ph(ph: float) -> float:
    # Ideal pH 7.0; full score at 7, decays toward 0 by pH 4 or 10.
    return max(0.0, 100.0 - abs(ph - 7.0) / 3.0 * 100.0)


def _sub_index_do(do: float) -> float:
    # >= 8 mg/L excellent, <= 2 mg/L unfit.
    return max(0.0, min(100.0, (do - 2.0) / (8.0 - 2.0) * 100.0))


def _sub_index_bod(bod: float) -> float:
    # <= 1 excellent, >= 15 unfit.
    return max(0.0, min(100.0, (15.0 - bod) / (15.0 - 1.0) * 100.0))


def _sub_index_turbidity(ntu: float) -> float:
    # <= 5 excellent, >= 150 unfit.
    return max(0.0, min(100.0, (150.0 - ntu) / (150.0 - 5.0) * 100.0))


def compute_wqi(metrics: dict[str, Any]) -> float | None:
    """Weighted sub-index WQI (0-100). Returns None if no usable metric."""
    parts: list[tuple[float, float]] = []  # (sub_index, weight)
    if metrics.get("ph") is not None:
        parts.append((_sub_index_ph(float(metrics["ph"])), 0.15))
    if metrics.get("dissolved_oxygen_mg_l") is not None:
        parts.append((_sub_index_do(float(metrics["dissolved_oxygen_mg_l"])), 0.35))
    if metrics.get("bod_mg_l") is not None:
        parts.append((_sub_index_bod(float(metrics["bod_mg_l"])), 0.30))
    if metrics.get("turbidity_ntu") is not None:
        parts.append((_sub_index_turbidity(float(metrics["turbidity_ntu"])), 0.20))
    if not parts:
        return None
    total_weight = sum(w for _, w in parts)
    wqi = sum(idx * w for idx, w in parts) / total_weight
    return round(wqi, 1)


def classify_wqi(wqi: float) -> str:
    if wqi >= 80:
        return "Good"
    if wqi >= 50:
        return "Moderate"
    if wqi >= 25:
        return "Poor"
    return "Unfit"


class WQIAnalyzer:
    def __init__(self) -> None:
        settings = get_settings()
        self._settings = settings
        self._model = settings.nvidia_model
        self._temperature = settings.llm_temperature
        self._client: OpenAI | None = None
        if settings.nvidia_api_key:
            self._client = OpenAI(api_key=settings.nvidia_api_key, base_url=settings.nvidia_base_url)

    def analyze(self, metrics: dict[str, Any]) -> AnalysisResult:
        wqi = compute_wqi(metrics)
        if wqi is None:
            return AnalysisResult(wqi=0.0, quality_class="Unfit", note="No usable metrics", llm_used=False)

        if self._client is None:
            return AnalysisResult(wqi=wqi, quality_class=classify_wqi(wqi), note="Rule-based (no LLM)", llm_used=False)

        try:
            return self._llm_classify(metrics, wqi)
        except Exception as exc:  # noqa: BLE001 - degrade gracefully to rule-based
            logger.warning("Analyzer LLM failed, using rule-based class: %s", exc)
            return AnalysisResult(wqi=wqi, quality_class=classify_wqi(wqi), note="Rule-based (LLM error)", llm_used=False)

    @retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=1, max=8))
    def _llm_classify(self, metrics: dict[str, Any], wqi: float) -> AnalysisResult:
        assert self._client is not None
        user_prompt = (
            f"WQI: {wqi}\n"
            f"METRICS:\n{json.dumps(metrics, indent=2)}\n\n"
            "Assign the quality class and a one-line note. JSON only."
        )
        response = self._client.chat.completions.create(
            model=self._model,
            temperature=self._temperature,
            messages=[
                {"role": "system", "content": ANALYSIS_SYSTEM_PROMPT},
                {"role": "user", "content": user_prompt},
            ],
            max_tokens=256,
        )
        content = (response.choices[0].message.content or "{}").strip()
        if content.startswith("```"):
            content = content.split("\n", 1)[-1].rsplit("```", 1)[0].strip()
        data = json.loads(content)
        quality_class = data.get("quality_class", classify_wqi(wqi))
        if quality_class not in QUALITY_CLASSES:
            quality_class = classify_wqi(wqi)
        return AnalysisResult(wqi=wqi, quality_class=quality_class, note=data.get("note", ""), llm_used=True)
