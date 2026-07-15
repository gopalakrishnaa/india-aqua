"""Streamlit BI dashboard for Ganga water quality."""

from __future__ import annotations

import os
from datetime import datetime

import httpx
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

API_BASE = os.getenv("API_BASE_URL", "http://localhost:8000")
API_KEY = os.getenv("GANGA_API_KEY", "")

st.set_page_config(page_title="Ganga Aqua BI", page_icon="💧", layout="wide")


def _headers() -> dict[str, str]:
    h: dict[str, str] = {}
    if API_KEY:
        h["X-API-Key"] = API_KEY
    return h


@st.cache_data(ttl=60)
def fetch_json(path: str, params: dict | None = None) -> list | dict:
    url = f"{API_BASE}{path}"
    with httpx.Client(timeout=30.0) as client:
        resp = client.get(url, headers=_headers(), params=params or {})
        resp.raise_for_status()
        return resp.json()


def status_color(do: float | None) -> str:
    if do is None:
        return "gray"
    if do >= 5.0:
        return "green"
    if do >= 3.0:
        return "orange"
    return "red"


st.title("💧 Ganga Aqua — Water Quality Intelligence")
st.caption("Validated readings from CPCB / Namami Gange / India WRIS sources")

if not API_KEY:
    st.warning("Set `GANGA_API_KEY` env var (from `ganga-aqua seed`) to load data.")

tab_status, tab_deficiency, tab_trends = st.tabs(["Current Status", "Data Deficiency", "Trends"])

with tab_status:
    st.subheader("Latest readings by station")
    try:
        readings = fetch_json("/api/v1/readings/latest")
        if not readings:
            st.info("No readings yet. Run `ganga-aqua seed` first.")
        else:
            df = pd.DataFrame(readings)
            cols = [
                "station_name",
                "ph",
                "dissolved_oxygen_mg_l",
                "bod_mg_l",
                "cod_mg_l",
                "turbidity_ntu",
                "temperature_c",
                "recorded_at",
            ]
            display = df[[c for c in cols if c in df.columns]].copy()
            display.columns = [
                "Station",
                "pH",
                "DO (mg/L)",
                "BOD",
                "COD",
                "Turbidity",
                "Temp (°C)",
                "Recorded",
            ]
            st.dataframe(display, use_container_width=True, hide_index=True)

            fig = go.Figure()
            for _, row in df.iterrows():
                do = row.get("dissolved_oxygen_mg_l")
                fig.add_trace(
                    go.Bar(
                        name=row.get("station_name", "?"),
                        x=[row.get("station_name")],
                        y=[do if do is not None else 0],
                        marker_color=status_color(do),
                        text=[f"{do:.1f}" if do else "N/A"],
                        textposition="outside",
                    )
                )
            fig.update_layout(
                title="Dissolved Oxygen by Station (green ≥5, orange ≥3, red <3 mg/L)",
                yaxis_title="DO (mg/L)",
                showlegend=False,
                height=400,
            )
            st.plotly_chart(fig, use_container_width=True)
    except httpx.HTTPError as exc:
        st.error(f"API error: {exc}. Is the server running on {API_BASE}?")

with tab_deficiency:
    st.subheader("Stations with missing or stale data")
    try:
        deficiencies = fetch_json("/api/v1/deficiency")
        if not deficiencies:
            st.success("All stations have recent, complete readings.")
        else:
            for item in deficiencies:
                with st.expander(f"⚠️ {item['station_name']} — {item['location']}", expanded=True):
                    for issue in item["issues"]:
                        st.markdown(f"- {issue}")
                    if item.get("last_reading_at"):
                        st.caption(f"Last reading: {item['last_reading_at']}")
    except httpx.HTTPError as exc:
        st.error(f"API error: {exc}")

with tab_trends:
    st.subheader("Historical trends")
    try:
        stations = fetch_json("/api/v1/stations")
        station_options = {s["name"]: s["id"] for s in stations}
        selected = st.selectbox("Station", options=list(station_options.keys()) or ["—"])
        days = st.slider("Days of history", min_value=7, max_value=90, value=30)

        if station_options and selected in station_options:
            history = fetch_json(
                "/api/v1/readings/history",
                params={"station_id": station_options[selected], "days": days},
            )
            if history:
                df = pd.DataFrame(history)
                df["recorded_at"] = pd.to_datetime(df["recorded_at"])
                df = df.sort_values("recorded_at")

                metric = st.selectbox(
                    "Metric",
                    ["dissolved_oxygen_mg_l", "ph", "bod_mg_l", "cod_mg_l", "turbidity_ntu"],
                    format_func=lambda x: {
                        "dissolved_oxygen_mg_l": "Dissolved Oxygen",
                        "ph": "pH",
                        "bod_mg_l": "BOD",
                        "cod_mg_l": "COD",
                        "turbidity_ntu": "Turbidity",
                    }.get(x, x),
                )
                fig = px.line(
                    df,
                    x="recorded_at",
                    y=metric,
                    title=f"{selected} — {metric} over {days} days",
                    markers=True,
                )
                st.plotly_chart(fig, use_container_width=True)

                col1, col2 = st.columns(2)
                with col1:
                    fig2 = px.scatter(df, x="recorded_at", y="ph", title="pH trend")
                    st.plotly_chart(fig2, use_container_width=True)
                with col2:
                    fig3 = px.scatter(df, x="recorded_at", y="bod_mg_l", title="BOD trend")
                    st.plotly_chart(fig3, use_container_width=True)
            else:
                st.info("No history for this station.")
    except httpx.HTTPError as exc:
        st.error(f"API error: {exc}")

st.sidebar.markdown("### About")
st.sidebar.markdown(
    "Data validated by LLM at temperature=0. "
    "Only readings that match raw scraped text are stored."
)
st.sidebar.caption(f"API: {API_BASE} · Updated {datetime.now():%Y-%m-%d %H:%M}")
